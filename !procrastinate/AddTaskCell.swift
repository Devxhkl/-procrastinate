//
//  AddTaskCell.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/11/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class AddTaskCell: UITableViewCell {
	
	@IBOutlet weak var titleTextView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		titleTextView.textContainerInset = UIEdgeInsetsZero
		titleTextView.textContainer.lineFragmentPadding = 0.0
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
