//
//  CloudKitHandler.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/12/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import CloudKit

class CloudHandler {
	let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
	
	func addTask(task: Task, completion: String -> ()) {
		let newTask = CKRecord(recordType: "Task")
		newTask.setValue(task.title, forKey: "Title")
		newTask.setValue(task.completed, forKey: "Completed")
		privateDatabase.saveRecord(newTask, completionHandler: { record, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				completion(record!.recordID.recordName)
				print("Saved \(record!["Title"] as! String)")
			}
		})
	}
	
	func getTasks(completion: [Task] -> ()) {
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//		print(calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])!)
//		print(calendar.dateByAddingUnit(.Hour, value: 5, toDate: calendar.startOfDayForDate(calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])!), options: [])!)
//		print(calendar.startOfDayForDate(NSDate()))
//		print(NSDate())
		let query = CKQuery(recordType: "Task", predicate: NSPredicate(format: "creationDate > %@", calendar.dateByAddingUnit(.Hour, value: 5, toDate: calendar.startOfDayForDate(calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])!), options: [])!))
		privateDatabase.performQuery(query, inZoneWithID: nil) { records, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				if let records = records {
					var tasks = [Task]()
					for record in records {
						let task = Task(ID: record.recordID.recordName, title: record["Title"] as! String, completed: record["Completed"] as! Bool)
						tasks.append(task)
					}
					tasks.sortInPlace { !$0.completed && $1.completed }
					completion(tasks)
				}
			}
		}
	}
	
	func changeTaskStatus(task: Task) {
		privateDatabase.fetchRecordWithID(CKRecordID(recordName: task.ID)) { record, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				if let record = record {
					record.setValue(task.completed, forKey: "Completed")
					self.privateDatabase.saveRecord(record) { savedRecord, error in
						if let error = error {
							print(error.localizedDescription)
						} else {
							print("Saved \(savedRecord!["Title"] as! String)'s completed to \(savedRecord!["Completed"] as! Bool)")
						}
					}
				}
			}
		}
	}
	
	func changeTaskTitle(task: Task) {
		privateDatabase.fetchRecordWithID(CKRecordID(recordName: task.ID)) { record, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				if let record = record {
					record.setValue(task.title, forKey: "Title")
					self.privateDatabase.saveRecord(record) { savedRecord, error in
						if let error = error {
							print(error.localizedDescription)
						} else {
							print("Saved \(savedRecord!["Title"] as! String)")
						}
					}
				}
			}
		}
	}
	
	func deleteTask(task: Task) {
		privateDatabase.deleteRecordWithID(CKRecordID(recordName: task.ID)) { record, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				print("\(record!) Deleted")
			}
		}
	}
	
	func getTaskCountWithSuccessRate(completion: String -> ()) {
		privateDatabase.fetchRecordWithID(CKRecordID(recordName: "Stats")) { (record, error) -> Void in
			if let error = error {
				print(error.localizedDescription)
			} else if let record = record {
				let taskCount = record["TaskCount"] as! Int
				let completedCount = record["CompletedCount"] as! Int
				completion("\(completedCount)/\(taskCount)")
			}
		}
	}
	
	func updateTaskCountWithSuccessRate(taskCount: Bool? = nil, completedCount: Bool? = nil, completion: String? -> ()) {
		privateDatabase.fetchRecordWithID(CKRecordID(recordName: "Stats")) { (record, error) -> Void in
			if let error = error {
				print(error.localizedDescription)
				completion(nil)
			} else if let record = record {
				if let taskCount = taskCount {
					var recordTaskCount = record["TaskCount"] as! Int
					record.setValue(taskCount ? ++recordTaskCount : --recordTaskCount, forKey: "TaskCount")
				}
				if let completedCount = completedCount {
					var recordCompletedCount = record["CompletedCount"] as! Int
					record.setValue(completedCount ? ++recordCompletedCount : --recordCompletedCount, forKey: "CompletedCount")
				}
				self.privateDatabase.saveRecord(record, completionHandler: { (updatedRecord, _error) -> Void in
					if let _error = _error {
						print(_error.localizedDescription)
						completion(nil)
					} else if let updatedRecord = updatedRecord {
						completion("\(updatedRecord["CompletedCount"] as! Int)/\(updatedRecord["TaskCount"] as! Int)")
					}
				})
			}
		}
	}
}
