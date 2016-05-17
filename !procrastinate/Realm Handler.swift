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
	var realm = try! Realm()
	
	var tasks = [Task]()
	
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
		let calendar = NSCalendar.currentCalendar()
		let today = calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])
		let todayStartOfDay = calendar.startOfDayForDate(today!)
		let today5AM = calendar.dateByAddingUnit(.Hour, value: 5, toDate: todayStartOfDay, options: [])
		
		tasks = Array(realm.objects(Task).filter("createdDate > %@", today5AM!.timeIntervalSinceReferenceDate).sorted("completed"))
		
		if let delegate = delegate {
			delegate.reloadData()
		}
	}
	
	func fetchUnsyncedTasks(lastSyncTime: NSDate) -> [Task]? {
		return nil
	}
}
