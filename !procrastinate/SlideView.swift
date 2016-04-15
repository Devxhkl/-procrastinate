//
//  SlideView.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/28/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import UIKit

class SlideView: NSObject {
	
	var view: UIView!
	var imageView: UIImageView!
	
	override init() {
		super.init()
		
		view = NSBundle.mainBundle().loadNibNamed("SlideView", owner: self, options: nil)[0] as! UIView
		imageView = view.subviews[0] as! UIImageView
	}
}
