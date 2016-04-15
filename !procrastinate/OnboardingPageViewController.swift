//
//  OnboardingPageViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/31/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
	
	@IBOutlet var backgroundView: UIView!
	@IBOutlet weak var iPhoneOutlineImageView: UIImageView!
	@IBOutlet weak var iPhoneOutlineImageViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var skipTutorialButton: UIButton!
	
	var onboardingViewControllers = [OnboardingViewController]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for i in 0...3 {
			let onboardingViewController = storyboard!.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
			onboardingViewController.index = i - 1
			onboardingViewControllers.append(onboardingViewController)
			if i == 0 {
				setViewControllers([onboardingViewController], direction: .Forward, animated: true, completion: nil)
			}
		}
		
		dataSource = self
		delegate = self
		
		makeup()
	}
	
	func makeup() {
		backgroundView.frame = view.frame
		view.insertSubview(backgroundView, belowSubview: view.subviews[0])
		view.backgroundColor = UIColor.whiteColor()
		
		let pageControllerAppearance = UIPageControl.appearance()
		pageControllerAppearance.backgroundColor = UIColor.whiteColor()
		pageControllerAppearance.pageIndicatorTintColor = UIColor.lightGrayColor()
		pageControllerAppearance.currentPageIndicatorTintColor = UIColor.blackColor()
		
		view.addSubview(skipTutorialButton)
		skipTutorialButton.translatesAutoresizingMaskIntoConstraints = false
		
		let views = ["skipButton": skipTutorialButton, "iPhoneImageView": iPhoneOutlineImageView]
		
		let skipButtonBottomConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
			"V:[iPhoneImageView]-[skipButton]-40-|",
			options: [.AlignAllCenterX],
			metrics: nil,
			views: views)
		NSLayoutConstraint.activateConstraints(skipButtonBottomConstraint)
		
		iPhoneOutlineImageViewWidthConstraint.constant = widthForScreenSize(true)
	}
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		switch viewController {
		case onboardingViewControllers[0]:
			return onboardingViewControllers[1]
		case onboardingViewControllers[1]:
			return onboardingViewControllers[2]
		case onboardingViewControllers[2]:
			return onboardingViewControllers[3]
		default:
			return nil
		}
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		switch viewController {
		case onboardingViewControllers[3]:
			return onboardingViewControllers[2]
		case onboardingViewControllers[2]:
			return onboardingViewControllers[1]
		case onboardingViewControllers[1]:
			return onboardingViewControllers[0]
		default:
			return nil
		}
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return onboardingViewControllers.count
	}
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		if (viewControllers!.last! as! OnboardingViewController).index == 2 {
			skipTutorialButton.setTitle("   Done   ", forState: .Normal)
		} else if skipTutorialButton.titleLabel?.text == "   Done   " {
			skipTutorialButton.setTitle("   Skip   ", forState: .Normal)
		}
	}
}
