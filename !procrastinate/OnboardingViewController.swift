//
//  OnboardingViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/31/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
	
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var textLabelWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var screensImageView: UIImageView!
	@IBOutlet weak var screensImageViewWidthConstraint: NSLayoutConstraint!
	
	var index: Int!
	let texts = ["Add New Tasks", "Mark as Done/Undone", "Delete", "Use the Today Widget"]
	
	override func viewDidLoad() {
		super.viewDidLoad()

		if index >= 0 {
			let numberOfImages = [5, 6, 3, 2]
			
			var images = [UIImage]()
			for i in 0...numberOfImages[index] {
				images.append(UIImage(named: "screen " + index.description + "." + i.description)!)
			}
			
			screensImageView.animationImages = images
			screensImageView.animationDuration = Double(numberOfImages[index]) * 0.5
			
			textLabel.text = texts[index]
		} else {
			textLabel.text = "Start Every Day With A Fresh List"
		}
		
		screensImageViewWidthConstraint.constant = widthForScreenSize(false)
		textLabelBottomConstraint.constant = textLabelBottomDistance()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		screensImageView.startAnimating()
	}
}
