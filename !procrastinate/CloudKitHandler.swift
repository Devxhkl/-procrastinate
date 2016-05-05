//
//  CloudKitHandler.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/4/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import CloudKit

class CKHandler {
	
	static let sharedInstance = CKHandler()
	
	let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
	
	func newTask(task: Task) {
		let recordID = CKRecordID(recordName: task.id!)
		let record = CKRecord(recordType: "Tasks", recordID: recordID)
		record["title"] = task.title!
		record["completed"] = task.completed
		record["createdDate"] = task.createdDate
		record["updatedDate"] = task.updatedDate
		record["completedDate"] = task.completedDate
		record["tag"] = Int(task.tag)
		
		saveRecord(record)
	}
	
	func updateTask(task: Task) {
		let recordID = CKRecordID(recordName: task.id!)
		
		privateDatabase.fetchRecordWithID(recordID) { (record, error) in
			if let record = record {
				record["title"] = task.title
				record["completed"] = task.completed
				record["updatedDate"] = task.updatedDate
				record["completedDate"] = task.completedDate
				record["tag"] = Int(task.tag)
				
				self.saveRecord(record)
			}
		}
	}
	
	func deleteTask(task: Task) {
		let recordID = CKRecordID(recordName: task.id!)
		
		privateDatabase.deleteRecordWithID(recordID) { (recordID, error) in
			if let recordID = recordID {
				print("Record deleted: " + recordID.recordName)
			} else {
				print(error)
			}
		}
	}
	
	func saveRecord(record: CKRecord) {
		privateDatabase.saveRecord(record) { (record, error) in
			if let record = record {
				print("Record saved: " + (record["title"] as! String))
			} else {
				print(error)
			}
		}
	}
}
