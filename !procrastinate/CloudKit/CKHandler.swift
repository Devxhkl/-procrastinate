//
//  CKHandler.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/5/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import CloudKit

class CKHandler {
	
	static let sharedInstance = CKHandler()
	
	let privateDatabase = CKContainer(identifier: "iCloud.com.zzzel.-procrastinate").privateCloudDatabase
	
	func newTask(task: Task) {
		let recordID = CKRecordID(recordName: task.id)
		let record = CKRecord(recordType: "Tasks", recordID: recordID)
		
		record["title"] = task.title
		record["completed"] = task.completed
		record["tag"] = Int(task.tag)
		record["createdDate"] = task.createdDate
		record["updatedDate"] = task.updatedDate
		record["completedDate"] = task.completedDate
		
		saveRecord(record)
	}
	
	func updateTask(task: Task) {
		let recordID = CKRecordID(recordName: task.id)
		privateDatabase.fetchRecordWithID(recordID) { (record, error) in
			dispatch_async(dispatch_get_main_queue()) {
				if let error = error {
					print(error)
				} else if let record = record {
					record["title"] = task.title
					record["completed"] = task.completed
					record["tag"] = Int(task.tag)
					record["updatedDate"] = task.updatedDate
					record["completedDate"] = task.completedDate
					
					self.saveRecord(record)
				}
			}
		}
	}
	
	func deleteTask(taskID: String) {
		let recordID = CKRecordID(recordName: taskID)
		
		privateDatabase.deleteRecordWithID(recordID) { (recordID, error) in
			if let error = error {
				print(error)
				if var tasksToDelete = NSUserDefaults.standardUserDefaults().valueForKey("tasksToDelete") as? [String] {
					tasksToDelete.append(taskID)
					NSUserDefaults.standardUserDefaults().setValue(tasksToDelete, forKey: "tasksToDelete")
				}
			} else if let recordID = recordID {
				print(recordID.recordName + " Deleted")
				NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: "lastSyncDate")
			}
		}
	}
	
	func saveRecord(record: CKRecord) {
		privateDatabase.saveRecord(record) { (record, error) in
			if let error = error {
				print(error)
			} else if let record = record {
				print("Record saved: \"" + (record["title"] as! String) + "\"")
				NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: "lastSyncDate")
			}
		}
	}
	
	func sync() {
		if Reachability.isConnectedToNetwork() {
			if let lastSyncDate = NSUserDefaults.standardUserDefaults().valueForKey("lastSyncDate") as? NSDate,
				unsyncedTasks = RealmHandler.sharedInstance.fetchUnsyncedTasks(lastSyncDate) {
				
				for task in unsyncedTasks {
					if task.createdDate > lastSyncDate.timeIntervalSinceReferenceDate {
						newTask(task)
					} else {
						updateTask(task)
					}
				}
				
				if let tasksToDelete = NSUserDefaults.standardUserDefaults().valueForKey("tasksToDelete") as? [String] {
					if !tasksToDelete.isEmpty {
						for taskID in tasksToDelete {
							deleteTask(taskID)
						}
						NSUserDefaults.standardUserDefaults().setValue([String](), forKey: "tasksToDelete")
					}
				}
			}
			NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: "lastSyncDate")
		} else {
			print("Unable to sync because the internet connection appears to be offline.")
		}
	}
	
	func cdToRealm() {
		let predicate = NSPredicate(format: "createdDate > %f", today5AM())
		let query = CKQuery(recordType: "Tasks", predicate: predicate)
		
		privateDatabase.performQuery(query, inZoneWithID: nil) { records, error in
			if let error = error {
				print(error)
			} else if let records = records {
				dispatch_async(dispatch_get_main_queue()) {
					for record in records {
						let task = Task()
						task.id = record.recordID.recordName
						task.title = record["title"] as! String
						task.completed = record["completed"] as! Bool
						task.tag = record["tag"] as! Int
						task.createdDate = record["createdDate"] as! Double
						task.completedDate = record["completedDate"] as! Double
						task.updatedDate = record["updatedDate"] as! Double
						
						RealmHandler.sharedInstance.cdRealmTask(task)
					}
					
					NSUserDefaults.standardUserDefaults().setBool(true, forKey: "cdToRealm")
				}
			}
		}
		takeOutTrash()
	}
	
	func takeOutTrash() {
		privateDatabase.performQuery(CKQuery(recordType: "Statistics", predicate: NSPredicate(value: true)), inZoneWithID: nil) { records, error in
			
			if let records = records {
				for record in records {
					self.privateDatabase.deleteRecordWithID(record.recordID) { recordID, error in
						print(recordID)
					}
				}
			}
		}
		
		privateDatabase.performQuery(CKQuery(recordType: "Task", predicate: NSPredicate(value: true)), inZoneWithID: nil) { records, error in
			
			if let records = records {
				for record in records {
					self.privateDatabase.deleteRecordWithID(record.recordID) { recordID, error in
						print(recordID)
					}
				}
			}
		}
		
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: "leftovers")
	}
	
}
