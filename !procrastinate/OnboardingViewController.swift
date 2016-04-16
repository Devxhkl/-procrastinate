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
	let texts = ["simply add new tasks...", "mark as done/undone...", "or delete."]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if index >= 0 {
			let numberOfImages = [6, 6, 4]
			
			var images = [UIImage]()
			for i in 0...numberOfImages[index] {
				images.append(UIImage(named: "slice " + index.description + "." + i.description)!)
			}
			
			screensImageView.animationImages = images
			screensImageView.animationDuration = Double(numberOfImages[index]) * 0.66
			
			textLabel.text = texts[index]
		} else {
			textLabel.text = "Start every day with a fresh list..."
		}
		
		textLabelWidthConstraint.constant = widthForScreenSize(true)
		screensImageViewWidthConstraint.constant = widthForScreenSize(false)
		textLabelBottomConstraint.constant = textLabelBottomDistance()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		screensImageView.startAnimating()
	}
}
