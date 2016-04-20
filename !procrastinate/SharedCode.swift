//
//  SharedCode.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import DeviceKit

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

func widthForScreenSize(big: Bool) -> CGFloat {
	switch Device() {
	case .iPhone5, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5s), .Simulator(.iPhoneSE):
		return big ? 260.0 : 222.0
	case .iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s):
		return big ? 315.0 : 268.0
	case .iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus):
		return big ? 354.0 : 301.0
	default:
		return big ? 260.0 : 222.0
	}
}

func textLabelBottomDistance() -> CGFloat {
	switch Device() {
	case .iPhone5, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5s), .Simulator(.iPhoneSE):
		return 100.0
	case .iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s):
		return 120.0
	case .iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus):
		return 140.0
	default:
		return 80.0
	}
}
