//
//  Entity+CoreDataProperties.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/30.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import Foundation
import CoreData

extension Entity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String
    @NSManaged public var created: Date
    @NSManaged public var label: String
    @NSManaged public var detail: String
    @NSManaged public var type: String
    @NSManaged public var pinned: Bool
    @NSManaged public var more: String
    @NSManaged public var value: Double
    @NSManaged public var image: String
}
