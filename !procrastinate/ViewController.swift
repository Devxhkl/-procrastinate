//
//  ViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CoreData

class Task {
	var id: String
	var title: String
	var completed: Bool
	var createdDate: NSDate
	var completedDate: NSDate?
	var tag: String?
	
	init(id: String, title: String, completed: Bool, createdDate: NSDate, completedDate: NSDate?, tag: String?) {
		self.id = id
		self.title = title
		self.completed = completed
		self.createdDate = createdDate
		if let completedDate = completedDate {
			self.completedDate = completedDate
		}
		if let tag = tag {
			self.tag = tag
		}
	}
}

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var successRateLabel: UILabel!
	
	let CDMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	var tasks: [Task] = []
	var placeholderCell: PlaceholderCell!
	var pullDownInProgress = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fetchRequest = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CDMOC)
		fetchRequest.entity = entityDescription
		let calendar = NSCalendar.currentCalendar()
		fetchRequest.predicate = NSPredicate(format: "createdDate > %@",
			calendar.dateByAddingUnit(.Hour,
				value: 5,
				toDate: calendar.startOfDayForDate(calendar.dateByAddingUnit(.Hour,
					value: -5,
					toDate: NSDate(),
					options: [])!),
				options: [])!)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "createdDate", ascending: false)]
		
		do {
			let result = try CDMOC.executeFetchRequest(fetchRequest)
			if !result.isEmpty {
				for cdTask in result as! [NSManagedObject] {
					let id = cdTask.valueForKey("id") as! String
					let title = cdTask.valueForKey("title") as! String
					let completed = cdTask.valueForKey("completed") as! Bool
					let createdDate = cdTask.valueForKey("createdDate") as! NSDate
					let completedDate = cdTask.valueForKey("completedDate") as? NSDate
					let tag = cdTask.valueForKey("tag") as? String
					
					let task = Task(id: id, title: title, completed: completed, createdDate: createdDate, completedDate: completedDate, tag: tag)
					tasks.append(task)
				}
				tableView.reloadData()
			}
		} catch {
			print(error)
		}
		
		navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: UIFontWeightUltraLight)]

//		didBecomeActive()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44.0
		placeholderCell = tableView.dequeueReusableCellWithIdentifier("PlaceholderCell") as! PlaceholderCell
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
	}

	func taskAdded() {
		let task = Task(id: "", title: "", completed: false, createdDate: NSDate(), completedDate: nil, tag: nil)
		tasks.insert(task, atIndex: 0)
		
		tableView.reloadData()
		
		let visibleCells = tableView.visibleCells as! [TaskCell]
		for cell in visibleCells {
			if cell.task === task {
//				cell.titleTextView.font = UIFont.systemFontOfSize(18)
				cell.titleTextView.becomeFirstResponder()
				break
			}
		}
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
//	func didBecomeActive() {
//		var isOneFinnished = false
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
//			self.cloudHandler.getTasks() { tasks in
//				self.tasks = tasks
//				dispatch_async(dispatch_get_main_queue(), { () -> Void in
//					self.tableView.reloadData()
//					if isOneFinnished {
//						self.activityIndicator.stopAnimating()
//					} else {
//						isOneFinnished = true
//					}
//				})
//			}
//			self.cloudHandler.getTaskCountWithSuccessRate() { result in
//				dispatch_async(dispatch_get_main_queue(), { () -> Void in
//					self.successRateLabel.text = result
//					if isOneFinnished {
//						self.activityIndicator.stopAnimating()
//					} else {
//						isOneFinnished = true
//					}
//				})
//			}
//		}
//	}
}

extension ViewController {
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		dismissKeyboard()
		pullDownInProgress = scrollView.contentOffset.y <= 0.0
		if pullDownInProgress {
			tableView.insertSubview(placeholderCell, atIndex: 0)
		}
	}
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let scrollViewContentOffsetY = scrollView.contentOffset.y
		
		if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
			placeholderCell.frame = CGRect(x: 0, y: -44.0, width: tableView.frame.size.width, height: 44.0)
			placeholderCell.feedbackLabel.text = -scrollViewContentOffsetY > 44.0 ? "release to add task" : "pull to add task"
			placeholderCell.alpha = min(1.0, -scrollViewContentOffsetY / 44.0)
		}
	}
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if pullDownInProgress && -scrollView.contentOffset.y > 44.0 {
			taskAdded()
		}
		placeholderCell.removeFromSuperview()
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell

		cell.delegate = self
		cell.task = tasks[indexPath.row]
		
		return cell
	}
}

extension ViewController: UITextViewDelegate {
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.text.isEmpty {
			textView.typingAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)]
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		let visibleCells = tableView.visibleCells as! [TaskCell]
		for cell in visibleCells {
			if cell.titleTextView === textView {
				if textView.text == "" {
					deleteTask(cell.task)
					break
				} else {
					cell.task.title = textView.text
					if cell.task.id == "" {
						let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CDMOC)
						let newTask = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CDMOC)
						let id = NSUUID().UUIDString
						newTask.setValue(id, forKey: "id")
						newTask.setValue(textView.text, forKey: "title")
						newTask.setValue(false, forKey: "completed")
						newTask.setValue(cell.task.createdDate, forKey: "createdDate")
						
						do {
							try newTask.managedObjectContext?.save()
							cell.task.id = id
						} catch {
							print(error)
						}
//						dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
//							self.cloudHandler.addTask(cell.task) { recordID in
//								cell.task.ID = recordID
//							}
//							self.cloudHandler.updateTaskCountWithSuccessRate(true, completeCount: nil) { stringResult in
//								if let stringResult = stringResult {
//									dispatch_async(dispatch_get_main_queue(), { () -> Void in
//										self.successRateLabel.text = stringResult
//									})
//								}
//							}
//						})
					} else {
						let fetctRequest = NSFetchRequest()
						let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CDMOC)
						fetctRequest.entity = entityDescription
						
						do {
							let result = try CDMOC.executeFetchRequest(fetctRequest)
							if !result.isEmpty {
								for task in result as! [NSManagedObject] {
									if (task.valueForKey("id") as! String) == cell.task.id {
										task.setValue(cell.task.title, forKey: "title")
										
										do {
											try task.managedObjectContext?.save()
										} catch {
											let saveError = error as NSError
											print(saveError)
										}
									}
								}
							}
						} catch {
							let fetchError = error as NSError
							print(fetchError)
						}
//						dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
//							self.cloudHandler.changeTaskTitle(cell.task)
//						})
					}
					break
				}
			}
		}
	}

	func textViewDidChange(textView: UITextView) {
		if textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height != textView.bounds.height {
			tableView.beginUpdates()
			textView.sizeToFit()
			tableView.endUpdates()
		} 
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
}

extension ViewController: TaskCellDelegate {
	
	func completeTask(task: Task) {
		tasks.sortInPlace { !$0.completed && $1.completed }
		tableView.beginUpdates()
		tableView.reloadData()
		tableView.endUpdates()
		
		let fetchRequest = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CDMOC)
		fetchRequest.entity = entityDescription
		
		do {
			let result = try CDMOC.executeFetchRequest(fetchRequest)
			
			if !result.isEmpty {
				for cdTask in result as! [NSManagedObject] {
					if (cdTask.valueForKey("id") as! String) == task.id {
						cdTask.setValue(task.completed, forKey: "completed")
						cdTask.setValue(task.completed ? NSDate() : nil, forKey: "completedDate")
						
						do {
							try cdTask.managedObjectContext?.save()
						} catch {
							let saveError = error as NSError
							print(saveError)
						}
					}
				}
			}
		} catch {
			let fetchError = error as NSError
			print(fetchError)
		}
//		dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
//			self.cloudHandler.changeTaskStatus(task)
//			self.cloudHandler.updateTaskCountWithSuccessRate(nil, completeCount: task.completed) { stringResult in
//				if let stringResult = stringResult {
//					dispatch_async(dispatch_get_main_queue(), { () -> Void in
//						self.successRateLabel.text = stringResult
//					})
//				}
//			}
//		}
	}
	func deleteTask(task: Task) {
		let index = tasks.indexOf { $0.title == task.title }
		tasks.removeAtIndex(index!)
		tableView.beginUpdates()
		tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Right)
		tableView.endUpdates()

		let fetchRequest = NSFetchRequest()
		let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: CDMOC)
		fetchRequest.entity = entityDescription
		
		do {
			let result = try CDMOC.executeFetchRequest(fetchRequest)
			
			if !result.isEmpty {
				for cdTask in result as! [NSManagedObject] {
					if (cdTask.valueForKey("id") as! String) == task.id {
						CDMOC.deleteObject(cdTask)
						
						do {
							try CDMOC.save()
						} catch {
							let saveError = error as NSError
							print(saveError)
						}
					}
				}
			}
		} catch {
			let fetchError = error as NSError
			print(fetchError)
		}
//		if !task.ID.isEmpty {
//			dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
//				self.cloudHandler.deleteTask(task)
//				self.cloudHandler.updateTaskCountWithSuccessRate(false, completeCount: nil) { stringResult in
//					if let stringResult = stringResult {
//						dispatch_async(dispatch_get_main_queue(), { () -> Void in
//							self.successRateLabel.text = stringResult
//						})
//					}
//				}
//			})
//		}
	}
}

