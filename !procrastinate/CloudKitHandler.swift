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
				print("Saved \(record!.recordID.recordName)")
			}
		})
	}
}
