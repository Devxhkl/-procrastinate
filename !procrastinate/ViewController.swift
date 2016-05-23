//
//  ViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var emptyListLabel: UILabel!
	
	var placeholderCell: PlaceholderCell!
	var tapToAddInProgress = false
	var newTaskInProgress = false
	var lastActiveTextView: UITextView?
	
	private let rowHeight: CGFloat = 42.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		RealmHandler.sharedInstance.delegate = self
		RealmHandler.sharedInstance.fetchTasks()

		didBecomeActive()
		
		navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.blackColor()]
		navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "pattern_done")!)
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = rowHeight
		
		placeholderCell = tableView.dequeueReusableCellWithIdentifier("PlaceholderCell") as! PlaceholderCell
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(didBecomeActive),
		                                                 name: UIApplicationDidBecomeActiveNotification,
		                                                 object: nil)
	}
	
	func newTask() {
		let task = Task()
		
		RealmHandler.sharedInstance.tasks.insert(task, atIndex: 0)
		
		reloadData()
		
		let visibleCells = tableView.visibleCells as! [TaskCell]
		visibleCells[0].titleTextView.becomeFirstResponder()
	}
	
	func resignResponder() {
		if let lastActiveTextView = lastActiveTextView {
			lastActiveTextView.resignFirstResponder()
		}
		
		if tapToAddInProgress {
			tapToAddInProgress = false
			return
		} else if RealmHandler.sharedInstance.tasks.isEmpty {
			tapToAddInProgress = true
			newTask()
		}
	}
	
	func didBecomeActive() {
		if let checkDate = NSUserDefaults.standardUserDefaults().valueForKey("checkDate") as? NSDate {
			if NSDate().timeIntervalSinceReferenceDate > checkDate.timeIntervalSinceReferenceDate {
				RealmHandler.sharedInstance.fetchTasks()
				newCheckDate()
			}
		}
	}
	
	func checkIfEmptyList() {
		if RealmHandler.sharedInstance.tasks.isEmpty {
			emptyListLabel.center = tableView.center
			tableView.addSubview(emptyListLabel)
		} else {
			emptyListLabel.removeFromSuperview()
		}
	}
}

extension ViewController {
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		resignResponder()
		
		tableView.insertSubview(placeholderCell, atIndex: 0)
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let scrollViewContentOffsetY = scrollView.contentOffset.y
		
		if scrollViewContentOffsetY < -rowHeight {
			scrollView.setContentOffset(CGPoint(x: 0.0, y: -rowHeight), animated: false)
			newTaskInProgress = true
		} else if scrollViewContentOffsetY < 0.0 {
			placeholderCell.frame = CGRect(x: 0, y: -rowHeight, width: tableView.frame.size.width, height: rowHeight)
			placeholderCell.alpha = min(1.0, -scrollViewContentOffsetY / rowHeight)
			newTaskInProgress = false
		}
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if newTaskInProgress {
			newTask()
			placeholderCell.removeFromSuperview()
		} else {
			checkIfEmptyList()
		}
	}
	
	func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
		if newTaskInProgress {
			scrollView.setContentOffset(CGPointZero, animated: false)
			newTaskInProgress = false
		}
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return RealmHandler.sharedInstance.tasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell

		cell.delegate = self
		cell.task = RealmHandler.sharedInstance.tasks[indexPath.row]
		
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
			deleted(task)
		} else {
			RealmHandler.sharedInstance.reload = false
			if task.createdDate == 0.0 {
				RealmHandler.sharedInstance.newTask(task, title: textView.text!)
			} else {
				RealmHandler.sharedInstance.updateTask(task, title: textView.text!)
			}
		}
	}
}

extension ViewController: TaskCellDelegate {
	
	func completedStateChanged() {
		RealmHandler.sharedInstance.tasks.sortInPlace { !$0.completed && $1.completed }
		
		reloadData()
	}
	
	func deleted(task: Task) {
		let index = RealmHandler.sharedInstance.tasks.indexOf { $0.id	== task.id }
		RealmHandler.sharedInstance.tasks.removeAtIndex(index!)
		
		tableView.beginUpdates()
		tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Right)
		tableView.endUpdates()
		
		if task.createdDate != 0.0 {
			RealmHandler.sharedInstance.reload = false
			RealmHandler.sharedInstance.deleteTask(task)
		}
		checkIfEmptyList()
	}
}

extension ViewController: RealmHandlerDelegate {
	
	func reloadData() {
		tableView.reloadData()
		checkIfEmptyList()
	}
}

