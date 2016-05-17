//
//  TodayCell.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/13/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class TodayCell: UITableViewCell {
	
	@IBOutlet weak var taskTitleLabel: UILabel!
	
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
	
}
