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
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	var tasks = [Task]()
	var delegate: TaskHandlerDelegate?
	
	func fetchTasks() {
		let fetchRequest = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
		fetchRequest.entity = entityDescription
		
		let calendar = NSCalendar.currentCalendar()
		let today = calendar.dateByAddingUnit(.Hour, value: -5, toDate: NSDate(), options: [])
		let todayStartOfDay = calendar.startOfDayForDate(today!)
		let today5AM = calendar.dateByAddingUnit(.Hour, value: 5, toDate: todayStartOfDay, options: [])
		
		fetchRequest.predicate = NSPredicate(format: "createdDate > %@", today5AM!)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "createdDate", ascending: false)]
		
		do {
			let result = try managedObjectContext.executeFetchRequest(fetchRequest)
			if let result = result as? [Task] {
				tasks = result
				if let delegate = delegate {
					delegate.reloadData()
				}
			}
		} catch {
			print(error)
		}
	}
	
	func newTask() {
		let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
		let task = Task(entity: taskEntity!, insertIntoManagedObjectContext: managedObjectContext)
		task.id = NSUUID().UUIDString
		task.createdDate = NSDate().timeIntervalSince1970
		
		tasks.insert(task, atIndex: 0)

		if let delegate = delegate {
			delegate.taskAdded(task)
		}
	}
	
	func deleteTask(task: Task) {
//		let index = tasks.indexOf { $0.title == task.title }
//		tasks.removeAtIndex(index!)
	}
}
