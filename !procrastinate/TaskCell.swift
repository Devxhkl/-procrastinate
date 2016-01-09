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
	
	@IBOutlet weak var titleLabel: UILabel!
	
	var delegate: TaskCellDelegate?
	var task: Task! {
		didSet {
			titleLabel.text = task.title
		}
	}
	
	var originalCenter = CGPoint()
	var markComplete = false, delete = false
	let stageView = UIView()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		
		let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
		recognizer.delegate = self
		addGestureRecognizer(recognizer)
	}
	
	func handlePan(recognizer: UIPanGestureRecognizer) {
		
		if recognizer.state == .Began {
			originalCenter = center
		}
		if recognizer.state == .Changed {
			let translation = recognizer.translationInView(self)
			center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
			
			markComplete = frame.origin.x > frame.size.width / 4.0 && frame.origin.x < (frame.size.width / 4.0) * 3
			if markComplete {
				stageView.backgroundColor = UIColor.greenColor()
			}
			delete = frame.origin.x > (frame.size.width / 3.0) * 2
			if delete {
				stageView.backgroundColor = UIColor.redColor()
			}
//			if frame.origin.x > frame.size.width / 4.0 {
//				stageView.backgroundColor = UIColor.grayColor()
//			}
		}
		if recognizer.state == .Ended {
			if markComplete {
				if let delegate = delegate {
					delegate.completeTask(task)
				}
				resetFrame()
			} else if delete {
				if let delegate = delegate {
					delegate.deleteTask(task)
					UIView.animateWithDuration(0.2, animations: { () -> Void in
						self.stageView.removeFromSuperview()
						}, completion: { _ in
//							self.stageView
					})
				}
			} else {
				resetFrame()
			}
		}
	}
	
	func resetFrame() {
		let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.frame = originalFrame
			}, completion: { _ in
				self.stageView.removeFromSuperview()
				self.stageView.backgroundColor = UIColor.whiteColor()
		})
	}
	
	override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			if fabs(translation.x) > fabs(translation.y) {
				stageView.frame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
				superview!.insertSubview(stageView, belowSubview: self)
				return true
			}
			return false
		}
		return false
	}
}
