//
//  AppDelegate.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		if NSUserDefaults.standardUserDefaults().boolForKey("oldUser") == false {
			let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
			if let onboardingPageViewController = onboardingStoryboard.instantiateViewControllerWithIdentifier("OnboardingPageViewController") as? OnboardingPageViewController {
				window?.rootViewController = onboardingPageViewController
				window?.makeKeyAndVisible()
				
				NSUserDefaults.standardUserDefaults().setBool(true, forKey: "oldUser")
				NSUserDefaults.standardUserDefaults().setValue([String](), forKey: "tasksToDelete")
				
				RealmHandler.sharedInstance.preloadTasks()
			}
			
			if NSUserDefaults.standardUserDefaults().valueForKey("checkDate") == nil {
				newCheckDate()
			}
		} else if !NSUserDefaults.standardUserDefaults().boolForKey("1.1.0") {
			let updateStoryboard = UIStoryboard(name: "Update", bundle: nil)
			if let updateViewController = updateStoryboard.instantiateInitialViewController() as? UpdateViewController {
				window?.rootViewController = updateViewController
				window?.makeKeyAndVisible()
				
//				NSUserDefaults.standardUserDefaults().setBool(true, forKey: "1.1.0")
			}
		}
		
		// Remove in 1.1.1
		if let _ = NSUserDefaults.standardUserDefaults().valueForKey("tasksToDelete") as? [Task] {
			NSUserDefaults.standardUserDefaults().setValue([String](), forKey: "tasksToDelete")
		}
		if NSUserDefaults.standardUserDefaults().valueForKey("cdToRealm") == nil {
			CKHandler.sharedInstance.cdToRealm()
		}
		if NSUserDefaults.standardUserDefaults().valueForKey("leftovers") == nil {
			CKHandler.sharedInstance.takeOutTrash()
		}
		
		return true
	}
	
	func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		CKHandler.sharedInstance.sync()
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

