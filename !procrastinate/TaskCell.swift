//
//  TaskCell.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

protocol TaskCellDelegate {
	func completeTask(task: Task)
	func deleteTask(task: Task)
}

class TaskCell: UITableViewCell {
	
	@IBOutlet weak var titleTextView: UITextView!
	
	var delegate: TaskCellDelegate?
	var task: Task! {
		didSet {
			strikesthroghOrNot()
		}
	}
	
	var originalCenter = CGPoint()
	var markComplete = false, delete = false
	let slide = SlideView()
	var stageView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		stageView = slide.view
		
		titleTextView.textContainerInset = UIEdgeInsetsZero
		titleTextView.textContainer.lineFragmentPadding = 0.0
		
		let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		addGestureRecognizer(recognizer)
		recognizer.delegate = self
	}
	
	func handlePan(recognizer: UIPanGestureRecognizer) {
		if recognizer.state == .Began {
			originalCenter = center
			stageView.alpha = 1.0
		}
		if recognizer.state == .Changed {
			let translation = recognizer.translationInView(self)
			if frame.origin.x < 0 {
				resetFrame()
				recognizer.enabled = false
			} else {
				center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
				stageView.center = CGPointMake((originalCenter.x - frame.width) + translation.x, stageView.center.y)
				
				markComplete = frame.origin.x > 0.0 && frame.origin.x < (frame.size.width / 4.0) * 3
				if markComplete && !task.completed {
					stageView.backgroundColor = UIColor(patternImage: UIImage(named: "done")!)
					slide.imageView.image = UIImage(named: "done_icon")
				} else {
					stageView.backgroundColor = UIColor(patternImage: UIImage(named: "undone")!)
					slide.imageView.image = UIImage(named: "undone_icon")
				}
				
				delete = frame.origin.x > (frame.size.width / 4.0) * 3
				if delete {
					stageView.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
					slide.imageView.image = UIImage(named: "delete_icon")
				}
			}
		}
		if recognizer.state == .Ended {
			recognizer.enabled = true
			
			if markComplete {
				if let delegate = delegate {
//					var taskValues: [String: AnyObject] = ["id": task.id,
//					                                       "completed": task.completed]
////					task.completed = !task.completed
//					if task.completed {
//						taskValues["completedDate"] = NSDate().timeIntervalSinceReferenceDate
////						task.completedDate = NSDate().timeIntervalSinceReferenceDate
//					} else {
//						taskValues["completedDate"] = 0.0
////						task.completedDate = 0.0
//					}
//					taskValues["taskUpdated"] = NSDate()
////					task.updatedDate = NSDate().timeIntervalSinceReferenceDate
//					
					RealmHandler.sharedInstance.updateTask(task, completed: !task.completed)
					delegate.completeTask(task)
					
					strikesthroghOrNot()
				}
				resetFrame()
				markComplete = false
			} else if delete {
				if let delegate = delegate {
					delegate.deleteTask(task)
					UIView.animateWithDuration(0.2, animations: {
						self.stageView.alpha = 0.0
						}, completion: { _ in
							self.stageView.removeFromSuperview()
					})
				}
			} else {
				resetFrame()
			}
		}
		if recognizer.state == .Cancelled {
			recognizer.enabled = true
		}
	}
	
	func resetFrame() {
		let slideViewOriginalFrame = CGRect(x: frame.origin.x - frame.width, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
		UIView.animateWithDuration(0.1, animations: { () -> Void in
			self.stageView.frame = slideViewOriginalFrame
			self.frame = CGRect(x: 0.0, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
			}, completion: { _ in
//				self.stageView.removeFromSuperview()
//				self.stageView.backgroundColor = UIColor.whiteColor()
		})
	}
	
	func strikesthroghOrNot() {
		var attributedString: NSAttributedString!
		
		if task.completed {
			attributedString = NSAttributedString(string: task.title, attributes: [NSStrikethroughStyleAttributeName: 1, NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightUltraLight)])
		} else {
			var taskTitle = ""
			if task.title != "" {
				taskTitle = task.title
			}
			attributedString = NSAttributedString(string: taskTitle, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)])
		}
		
		titleTextView.attributedText = attributedString
	}
	
	override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			if fabs(translation.x) > fabs(translation.y) {
				stageView.frame = CGRect(x: frame.origin.x - frame.size.width, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
				superview!.insertSubview(stageView, belowSubview: self)
				return true
			}
			return false
		}
		return false
	}
}
