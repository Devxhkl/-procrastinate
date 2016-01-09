//
//  TaskCell.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
	
	var originalCenter = CGPoint()
	var deleteOnDragRelease = false
	
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
			deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
		}
		if recognizer.state == .Ended {
			let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
			if !deleteOnDragRelease {
				UIView.animateWithDuration(0.2, animations: { self.frame = originalFrame })
			}
		}
	}
	
	override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			if fabs(translation.x) > fabs(translation.y) {
				return true
			}
			return false
		}
		return false
	}
}
