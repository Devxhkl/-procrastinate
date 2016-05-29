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
	
	class MockRealm: NSObject, UITableViewDataSource {
		
		var arr = ["One", "Two"]
		
		func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return arr.count
		}
		
		func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			let cell = UITableViewCell()
			
			cell.textLabel?.text = arr[indexPath.row]
			
			return cell
		}
	}
	
	var viewController: ViewController!
	var mockRealm: MockRealm!
	
	override func setUp() {
		super.setUp()
		
		viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
		
		_ = viewController.view
		
		mockRealm = MockRealm()
		viewController.tableView.dataSource = mockRealm
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testTableViewDataSource() {
		XCTAssert(viewController.tableView.dataSource! === mockRealm, "TableView Data Source is not MockRealm")
		
		XCTAssert(mockRealm.tableView(viewController.tableView, numberOfRowsInSection: 0) == 2, "Number of rows is not 2")
	}
	
	func testTimeReset() {
		mockRealm.arr = [String]()
		viewController.tableView.reloadData()
		
		XCTAssert(viewController.tableView.visibleCells.isEmpty, "There are still visible cells")
	}
	
}
