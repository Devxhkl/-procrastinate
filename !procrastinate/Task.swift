//
//  Task.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation

class Task {
	var ID: String
	var title: String
	var completed: Bool
	
	init(ID: String = "", title: String, completed: Bool = false) {
		self.ID = ID
		self.title = title
		self.completed = completed
	}
}
