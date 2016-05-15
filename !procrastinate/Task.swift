//
//  Task.swift
//  !procrastinate
//
//  Created by Zel Marko on 5/15/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
	dynamic var id: String = ""
	dynamic var title: String = ""
	dynamic var completed: Bool = false
	dynamic var tag: Int = 0
	dynamic var createdDate: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate
	dynamic var completedDate: NSTimeInterval = 0.0
	dynamic var updatedDate: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate
	
	override static func primaryKey() -> String? {
		return "id"
	}
}
