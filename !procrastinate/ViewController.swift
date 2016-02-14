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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var successRateLabel: UILabel!
	
//	let cloudHandler = CloudHandler()
	var tasks: [Task] = []
	var placeholderCell: PlaceholderCell!
	var pullDownInProgress = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		let task = Task()
		tasks.insert(task, atIndex: 0)
		
		tableView.reloadData()
		
		let visibleCells = tableView.visibleCells as! [TaskCell]
		for cell in visibleCells {
			if cell.task === task {
				let regularString = NSAttributedString(string: task.title)
				cell.titleTextView.attributedText = regularString
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
	
	func textViewDidEndEditing(textView: UITextView) {
		let visibleCells = tableView.visibleCells as! [TaskCell]
		for cell in visibleCells {
			if cell.titleTextView === textView {
				if textView.text == "" {
					deleteTask(cell.task)
					break
				} else {
					cell.task.title = textView.text
//					if cell.task.ID == "" {
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
//					} else {
//						dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
//							self.cloudHandler.changeTaskTitle(cell.task)
//						})
//					}
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

