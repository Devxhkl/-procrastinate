//
//  OnboardingPageViewController.swift
//  !procrastinate
//
//  Created by Zel Marko on 4/20/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController {
	
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var skipTutorialButton: UIButton!
	@IBOutlet weak var iPhoneSliceImageView: UIImageView!
	@IBOutlet weak var iPhoneSliceImageViewWidthConstraint: NSLayoutConstraint!
	
	var pageContainer: UIPageViewController!
	var pages = [OnboardingViewController]()
	
	var currentIndex: Int?
	private var pendingIndex: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for i in -1...2 {
			let page = storyboard!.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
			page.index = i
			pages.append(page)
		}
		
		pageContainer = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
		pageContainer.dataSource = self
		pageContainer.delegate = self
		pageContainer.setViewControllers([pages[0]], direction: .Forward, animated: false, completion: nil)
		
		view.addSubview(pageContainer.view)
		view.bringSubviewToFront(pageControl)
		view.bringSubviewToFront(skipTutorialButton)
		view.bringSubviewToFront(iPhoneSliceImageView)
		
		iPhoneSliceImageViewWidthConstraint.constant = widthForScreenSize(true)
	}
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		let currentIndex = pages.indexOf(viewController as! OnboardingViewController)!
		if currentIndex == 0 {
			return nil
		}
		let previousIndex = abs((currentIndex - 1) % pages.count)
		return pages[previousIndex]
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		let currentIndex = pages.indexOf(viewController as! OnboardingViewController)!
		if currentIndex == pages.count - 1 {
			return nil
		}
		let nextIndex = abs((currentIndex + 1) % pages.count)
		return pages[nextIndex]
	}
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
	func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
		
		pendingIndex = pages.indexOf(pendingViewControllers.first! as! OnboardingViewController)
	}
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		if completed {
			currentIndex = pendingIndex
			if let index = currentIndex {
				pageControl.currentPage = index
				if index == 3 {
					skipTutorialButton.setTitle("Done", forState: .Normal)
				} else if index == 2 {
					skipTutorialButton.setTitle("Skip", forState: .Normal)
				}
			}
		}
	}
}