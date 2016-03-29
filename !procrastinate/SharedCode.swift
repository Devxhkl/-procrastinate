//
//  SharedCode.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation

func newCheckDate() {
	let calendar = NSCalendar.currentCalendar()
	var nextCheckDate: NSDate!
	if calendar.component(.Hour, fromDate: NSDate()) < 5 {
		nextCheckDate = calendar.dateByAddingUnit(.Hour, value: 5, toDate: calendar.startOfDayForDate(NSDate()), options: [])
	} else {
		let components = NSDateComponents()
		components.day = 1
		components.hour = 5
		nextCheckDate = calendar.dateByAddingComponents(components, toDate: calendar.startOfDayForDate(NSDate()), options: [])
	}
	NSUserDefaults.standardUserDefaults().setValue(nextCheckDate, forKey: "checkDate")
}
