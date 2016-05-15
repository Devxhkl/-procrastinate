//
//  TaskHandler.swift
//  !procrastinate
//
//  Created by Zel Marko on 4/23/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CoreData

protocol TaskHandlerDelegate {
	func reloadData()
	func taskAdded(task: Task)
}

class TaskHandler {
	
	static let sharedInstance = TaskHandler()
	
	var managedObjectContext: NSManagedObjectContext!
	var delegate: TaskHandlerDelegate?
	var tasks = [Task]()
	
//	func fetchTasks() {
//		let fetchRequest = NSFetchRequest()
//		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)!
//		fetchRequest.entity = entityDescription
//		
//		let calendar = NSCalendar.currentCalendar()
//		let today = calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])
//		let todayStartOfDay = calendar.startOfDayForDate(today!)
//		let today5AM = calendar.dateByAddingUnit(.Hour, value: 5, toDate: todayStartOfDay, options: [])
//		
//		fetchRequest.predicate = NSPredicate(format: "createdDate > %@", today5AM!)
//		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "createdDate", ascending: false)]
//		
//		do {
//			let result = try managedObjectContext.executeFetchRequest(fetchRequest)
//			if let result = result as? [Task] {
//				tasks = result
//				
//				if let delegate = delegate {
//					delegate.reloadData()
//				}
//			}
//		} catch {
//			print(error)
//		}
//	}
	
	func fetchUnsyncedTasks(lastSyncTime: NSDate) -> [Task]? {
//		let fetchRequest = NSFetchRequest()
//		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)!
//		fetchRequest.entity = entityDescription
//		
//		fetchRequest.predicate = NSPredicate(format: "updatedDate > %@", lastSyncTime)
//		
//		do {
//			let result = try managedObjectContext.executeFetchRequest(fetchRequest)
//			if let result = result as? [Task] {
//				return result
//			}
//		} catch {
//			print(error)
//		}
//		
		return nil
	}
	
	func newTask() {
//		let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)!
//		
//		let task = Task(entity: taskEntity, insertIntoManagedObjectContext: managedObjectContext)
//		task.createdDate = NSDate().timeIntervalSinceReferenceDate
//		task.updatedDate = NSDate().timeIntervalSinceReferenceDate
//		
//		tasks.insert(task, atIndex: 0)
//
//		if let delegate = delegate {
//			delegate.taskAdded(task)
//		}
	}
	
	func preloadTasks() {
//		let texts = ["Delete this one", "This one needs to be done", "Edit this task by tapping on it", "This one is already done"]
//		for i in 0...3 {
//			let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)!
//			
//			let task = Task(entity: taskEntity, insertIntoManagedObjectContext: managedObjectContext)
//			task.id = NSUUID().UUIDString
//			task.title = texts[i]
//			task.createdDate = NSDate().timeIntervalSinceReferenceDate
//			if i == 3 {
//				task.completed = true
//				task.completedDate = NSDate().timeIntervalSinceReferenceDate
//			}
//			tasks.append(task)
//		}
	}
	
	func deleteTask(task: Task) {
//		managedObjectContext.deleteObject(task)
//		
//		if let _ = task.id {
//			CKHandler.sharedInstance.deleteTask(task)
//		}
//		
//		saveContext()
	}
	
	func saveContext() {
//		if managedObjectContext.hasChanges {
//			do {
//				try managedObjectContext.save()
//			}
//			catch {
//				print(error)
//			}
//		}
	}
}
