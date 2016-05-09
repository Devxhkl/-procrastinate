//
//  ViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	let taskHandler = TaskHandler.sharedInstance
	var placeholderCell: PlaceholderCell!
	var pullDownInProgress = false
	var tapToAddInProgress = false
	var lastActiveTextView: UITextView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		taskHandler.delegate = self
		taskHandler.fetchTasks()

		didBecomeActive()
		
		navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.whiteColor()]
		navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "pattern_done")!)
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44.0
		
		placeholderCell = tableView.dequeueReusableCellWithIdentifier("PlaceholderCell") as! PlaceholderCell
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(didBecomeActive),
		                                                 name: UIApplicationDidBecomeActiveNotification,
		                                                 object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, 
		                                                 selector: #selector(resignResponder),
		                                                 name: UIApplicationWillResignActiveNotification,
		                                                 object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, 
		                                                 selector: #selector(resignResponder),
		                                                 name: UIApplicationWillTerminateNotification,
		                                                 object: nil)
	}
	
	func resignResponder() {
		if let lastActiveTextView = lastActiveTextView {
			lastActiveTextView.resignFirstResponder()
		}
		
		if tapToAddInProgress {
			tapToAddInProgress = false
			return
		} else if taskHandler.tasks.isEmpty && !pullDownInProgress {
			tapToAddInProgress = true
			taskHandler.newTask()
		}
	}
	
	func didBecomeActive() {
		if let checkDate = NSUserDefaults.standardUserDefaults().valueForKey("checkDate") as? NSDate {
			if NSDate().timeIntervalSinceReferenceDate > checkDate.timeIntervalSinceReferenceDate {
				taskHandler.fetchTasks()
				newCheckDate()
			}
		}
	}
}

extension ViewController {
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		resignResponder()
		if !tapToAddInProgress {
			pullDownInProgress = scrollView.contentOffset.y <= 0.0
			if pullDownInProgress {
				tableView.insertSubview(placeholderCell, atIndex: 0)
			}
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
			taskHandler.newTask()
		}
		pullDownInProgress = false
		placeholderCell.removeFromSuperview()
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return taskHandler.tasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell

		cell.delegate = self
		cell.task = taskHandler.tasks[indexPath.row]
		
		return cell
	}
}

extension ViewController: UITextViewDelegate {
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.text.isEmpty {
			textView.typingAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)]
		}
		
		lastActiveTextView = textView
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
	
	func textViewDidEndEditing(textView: UITextView) {
		let task = (textView.superview!.superview as! TaskCell).task
		
		if textView.text == "" {
			deleteTask(task)
		} else {
			task.title = textView.text
			task.updatedDate = NSDate.timeIntervalSinceReferenceDate()
			
			if let _ = task.id {
				CKHandler.sharedInstance.updateTask(task)
			} else {
				task.id = NSUUID().UUIDString
				CKHandler.sharedInstance.newTask(task)
			}
			
			taskHandler.saveContext()
		}
		textView.resignFirstResponder()
	}
}

extension ViewController: TaskCellDelegate {
	
	func completeTask(task: Task) {
		taskHandler.tasks.sortInPlace { !$0.completed && $1.completed }
		tableView.beginUpdates()
		reloadData()
		tableView.endUpdates()
		
		CKHandler.sharedInstance.updateTask(task)
		
		taskHandler.saveContext()
	}
	
	func deleteTask(task: Task) {
		let index = taskHandler.tasks.indexOf { $0.id	== task.id }
		taskHandler.tasks.removeAtIndex(index!)
		
		tableView.beginUpdates()
		tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Right)
		tableView.endUpdates()

		taskHandler.deleteTask(task)
	}
}

extension ViewController: TaskHandlerDelegate {
	
	func reloadData() {
		tableView.reloadData()
	}
	
	func taskAdded(task: Task) {
		reloadData()
		
		let visibleCells = tableView.visibleCells as! [TaskCell]
		visibleCells[0].titleTextView.becomeFirstResponder()
	}
}

