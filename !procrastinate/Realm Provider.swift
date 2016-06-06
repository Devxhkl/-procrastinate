//
//  Realm Provider.swift
//  To-day
//
//  Created by Zel Marko on 6/2/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
	class func realm() -> Realm  {
		if let _ = NSClassFromString("XCTest") {
			Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "RealmTests"
			
			return try! Realm()
		} else {
			let container = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.zzzel.to-day")!
			let realmURL = container.URLByAppendingPathComponent("db.realm")
			var config = Realm.Configuration()
			config.fileURL = realmURL
			Realm.Configuration.defaultConfiguration = config
			
			return try! Realm()
		}
	}
}
