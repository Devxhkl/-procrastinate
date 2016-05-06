//
//  Task+CoreDataProperties.swift
//  !procrastinate
//
//  Created by Zel Marko on 4/23/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var completed: Bool
    @NSManaged var completedDate: NSTimeInterval
    @NSManaged var createdDate: NSTimeInterval
    @NSManaged var id: String?
    @NSManaged var tag: Int16
    @NSManaged var title: String?

}
