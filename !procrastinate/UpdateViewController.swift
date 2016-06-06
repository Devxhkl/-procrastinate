//
//  UpdateViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/24/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
	
	@IBOutlet weak var skipButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		skipButton.layer.borderColor = UIColor.whiteColor().CGColor
	}
	
	@IBAction func leaveAReviewTapped(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1079983430&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
}
