//
//  Task.swift
//  !procrastinate
//
//  Created by Zel Marko on 1/9/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation

class Task {
	
	var title: String
	var completed: Bool
	
	init(title: String, completed: Bool = false) {
		self.title = title
		self.completed = completed
	}
}
