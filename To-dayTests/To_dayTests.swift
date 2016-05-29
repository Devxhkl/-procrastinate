//
//  To_dayTests.swift
//  To-dayTests
//
//  Created by Zel Marko on 5/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import XCTest
@testable import To_day

class To_dayTests: XCTestCase {
	
	var viewController: ViewController!
	
	override func setUp() {
		super.setUp()
		
		viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testSomething() {
		XCTAssertNil(viewController.tableView, "tableView is not nil")
		
//		let _ = viewController.view
		
		XCTAssertNotNil(viewController.tableView, "tableView is nil")
	}
	
}
