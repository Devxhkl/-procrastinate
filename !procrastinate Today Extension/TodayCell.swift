//
//  TodayCell.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/13/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

protocol TodayCellDelegate {
	func completedStateChanged()
}

class TodayCell: UITableViewCell {
	
	@IBOutlet weak var taskTitleLabel: UILabel!
	@IBOutlet weak var tickButton: UIButton!
	
	var delegate: TodayCellDelegate?
	
	var task: Task! {
		didSet {
			setAppropriateAttributes()
		}
	}
	
	@IBAction func tickButtonTapped(sender: UIButton) {
		RealmHandler.sharedInstance.reload = true
		RealmHandler.sharedInstance.updateTask(task, completed: !task.completed)
		
		setAppropriateAttributes()
		
		if let delegate = delegate {
			delegate.completedStateChanged()
		}
	}
	
	func setAppropriateAttributes() {
		var attributes: [String: AnyObject]!
		var imageName: String!
		
		if task.completed {
			attributes = [NSStrikethroughStyleAttributeName: 1,
			              NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightUltraLight)]
			imageName = "done"
		} else {
			attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)]
			imageName = "undone"
		}
		
		taskTitleLabel.attributedText = NSAttributedString(string: task.title, attributes: attributes)
		tickButton.setImage(UIImage(named: imageName)!, forState: .Normal)
	}
}
