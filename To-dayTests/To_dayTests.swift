//
//  To_dayTests.swift
//  To-dayTests
//
//  Created by Zel Marko on 5/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import XCTest
import RealmSwift

@testable
import To_day

class To_dayTests: XCTestCase {
	
	var viewController: ViewController!
	
	override func setUp() {
		super.setUp()
		
		viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
		_ = viewController.view
		
		try! RealmHandler.sharedInstance.realm.write {
			RealmHandler.sharedInstance.realm.deleteAll()
		}
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func test_morningResetTableView_isEmpty() {
		let testTask1 = Task()
		RealmHandler.sharedInstance.newTask(testTask1, title: "Test Task 1")
		let testTask2 = Task()
		RealmHandler.sharedInstance.newTask(testTask2, title: "Test Task 2")
		
		RealmHandler.sharedInstance.fetchTasks()
		
		XCTAssertEqual(viewController.tableView.numberOfRowsInSection(0), 2, "number of rows should be 2")
		
		viewController.didBecomeActive()
		
		// Change today5AM to return NSDate().timeIntervalSinceReferenceData -1
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
			XCTAssertEqual(self.viewController.tableView.numberOfRowsInSection(0), 0, "number of rows should be 0")
		}
	}
	
}
