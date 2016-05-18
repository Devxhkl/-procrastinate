//
//  TodayViewController.swift
//  !procrastinate Today Extension
//
//  Created by Zel Marko on 1/21/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		RealmHandler.sharedInstance.delegate = self
		RealmHandler.sharedInstance.fetchTasks()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44.0
		
		preferredContentSize = CGSize(width: preferredContentSize.width, height: 200.0)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
		// Perform any setup necessary in order to update the view.
		
		// If an error is encountered, use NCUpdateResult.Failed
		// If there's no update required, use NCUpdateResult.NoData
		// If there's an update, use NCUpdateResult.NewData
		
		completionHandler(NCUpdateResult.NewData)
	}
	
	func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
}

extension TodayViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return RealmHandler.sharedInstance.tasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TodayCell", forIndexPath: indexPath) as! TodayCell
		
		cell.delegate = self
		cell.task = RealmHandler.sharedInstance.tasks[indexPath.row]

		return cell
	}
}

extension TodayViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("Cell")
	}
}

extension TodayViewController: TodayCellDelegate {
	func completedStateChanged() {
		RealmHandler.sharedInstance.tasks.sortInPlace { !$0.completed && $1.completed }
		
		tableView.beginUpdates()
		reloadData()
		tableView.endUpdates()
	}
}

extension TodayViewController: RealmHandlerDelegate {
	func reloadData() {
		tableView.reloadData()
	}
}

