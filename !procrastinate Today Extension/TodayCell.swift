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
	
	var delegate: TodayCellDelegate?
	
	var task: Task! {
		didSet {
			strikesthroghOrNot()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	@IBAction func tickButtonTapped(sender: UIButton) {
		sender.setImage(UIImage(named: "done"), forState: .Normal)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
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
		
		taskTitleLabel.attributedText = attributedString
	}
	
}
