//
//  Entity+CoreDataClass.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/30.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

@objc(Entity)
public class Entity: NSManagedObject {
    func link () -> URL? {
        return URL(string: more)
    }

    var color: UIColor {
        get {
            if type == "Chart" {
                return UIColor.cyan
            }
            let elapsed = Date().timeIntervalSince(self.created)
            if elapsed > 0 {
                return UIColor.red
            }
            return UIColor.green
        }
    }

    func format() -> String {
        if type == "Chart" {
            return detail
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .positional

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current

        var elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            let formattedString = formatter.string(from: TimeInterval(elapsed))!
            return formattedString + " since "
        } else {
            elapsed *= -1
            let formattedString = formatter.string(from: TimeInterval(elapsed))!
            return formattedString + " until "
        }
    }

    static func fromJson(countdown: JSON, context: NSManagedObjectContext) -> Entity {
        let entity = Entity(context: context)

        let dateParser = DateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateParser.timeZone = TimeZone(abbreviation: "UTC")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current

        entity.id = countdown["id"].stringValue
        entity.type = "Countdown"
        entity.label = countdown["label"].stringValue
        entity.more = countdown["more"].stringValue
        entity.created = dateParser.date(from: countdown["created"].stringValue)!
        entity.detail = dateFormatter.string(from: entity.created)

        return entity
    }

    static func fromJson(chart: JSON, context: NSManagedObjectContext) -> Entity {
        let entity = Entity(context: context)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        entity.id = chart["id"].stringValue
        entity.type = "Chart"
        entity.label = chart["label"].stringValue
        entity.detail = chart["value"].stringValue
        entity.more = chart["more"].stringValue
        entity.created = dateFormatter.date(from: chart["created"].stringValue)!
        
        return entity
    }
}
