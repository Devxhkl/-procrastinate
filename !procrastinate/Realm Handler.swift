//
//  Realm Handler.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/15/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmHandlerDelegate {
	func reloadData()
}

class RealmHandler {
	
	static let sharedInstance = RealmHandler()
	
	var delegate: RealmHandlerDelegate?
	var realm = RealmProvider.realm()
	var token: NotificationToken!
	
	var tasks = [Task]()
	var reload = true
	
	func newTask(task: Task, title: String) {
		let now = NSDate().timeIntervalSinceReferenceDate
		
		task.title = title
		task.createdDate = now
		task.updatedDate = now
		
		do {
			try realm.write() {
				realm.add(task)
				
				CKHandler.sharedInstance.newTask(task)
			}
		} catch {
			print(error)
		}
	}
	
	func updateTask(task: Task, title: String? = nil, completed: Bool? = nil) {
		do {
			try realm.write {
				let now = NSDate().timeIntervalSinceReferenceDate
				
				if let title = title {
					task.title = title
				} else if let completed = completed {
					task.completed = completed
					task.completedDate = completed ? now : 0.0
				}
				task.updatedDate = now
				
				CKHandler.sharedInstance.updateTask(task)
			}
		} catch {
			print(error)
		}
	}
	
	func deleteTask(task: Task) {
		do {
			try realm.write {
				let id = task.id
				
				realm.delete(task)
				
				CKHandler.sharedInstance.deleteTask(id)
			}
		} catch {
			print(error)
		}
	}
	
	func fetchTasks() {
		let results = realm.objects(Task).filter("createdDate > %@", today5AM()).sorted("completed")
		self.tasks = Array(results)
		
		token = results.addNotificationBlock() { (changes: RealmCollectionChange) in
			if self.reload {
				self.tasks.sortInPlace { !$0.completed && $1.completed }
				if let delegate = self.delegate {
					delegate.reloadData()
				}
			}
		}
	}
	
	func fetchUnsyncedTasks(lastSyncTime: NSDate) -> [Task]? {
		return Array(realm.objects(Task).filter("updatedDate > %@", lastSyncTime.timeIntervalSinceReferenceDate))
	}
	
	func preloadTasks() {
		let texts = ["Delete this one", "This one needs to be done", "Edit this task by tapping on it", "This one is already done"]
		for i in 0...3 {
			let task = Task()
			if i == 3 {
				task.completed = true
				task.completedDate = NSDate().timeIntervalSinceReferenceDate
			}
			newTask(task, title: texts[i])
		}
	}
	
	deinit {
		token.stop()
	}
	
	// Remove in 1.1.1
	func cdRealmTask(task: Task) {
		do {
			try realm.write() {
				realm.add(task, update: true)
			}
		} catch {
			print(error)
		}
	}
	
}
