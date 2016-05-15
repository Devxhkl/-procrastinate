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
	func taskAdded(task: Task)
}

class RealmHandler {
	
	static let sharedInstance = RealmHandler()
	
	var delegate: RealmHandlerDelegate?
	let realm = try! Realm()
	
	var tasks = [Task]()
	
	func newTask() {
		let task = Task()
		
		tasks.insert(task, atIndex: 0)
		
		print(task.title)
		print(task.id)
		if let delegate = delegate {
			delegate.taskAdded(task)
		}
	}
	
	func updateTask(task: [String: AnyObject]) {
		do {
			try realm.write {
				realm.create(Task.self, value: task, update: true)
				print(task)
			}
		} catch {
			print(error)
		}
	}
	
	func deleteTask(task: Task) {
		do {
			try realm.write {
				realm.delete(task)
			}
		} catch {
			print(error)
		}
		
		if task.id != "" {
			CKHandler.sharedInstance.deleteTask(task)
		}
	}
	
	func fetchTasks() {
		let calendar = NSCalendar.currentCalendar()
		let today = calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])
		let todayStartOfDay = calendar.startOfDayForDate(today!)
		let today5AM = calendar.dateByAddingUnit(.Hour, value: 5, toDate: todayStartOfDay, options: [])
		
		let objects = realm.objects(Task).filter("createdDate > %@", today5AM!.timeIntervalSinceReferenceDate)
		tasks = Array(objects)
		
		if let delegate = delegate {
			delegate.reloadData()
		}
	}
	
	func fetchUnsyncedTasks(lastSyncTime: NSDate) -> [Task]? {
		return nil
	}
}
