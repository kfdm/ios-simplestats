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

class WidgetColor {
    static let overdue = UIColor.red
    static let countdown = UIColor.green
    static let chart = UIColor.lightGray
}

@objc(Entity)
public class Entity: NSManagedObject {
    var link: URL? {
        return URL(string:more)
    }

    var icon: URL? {
        return URL(string: image)
    }

    var color: UIColor {
        if type == "Chart" {
            return WidgetColor.chart
        }
        let elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            return WidgetColor.overdue
        }
        return WidgetColor.countdown
    }

    var fgColor: UIColor {
        if type == "Chart" {
            return UIColor.purple
        }
        let elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            return UIColor.orange
        }
        return UIColor.blue
    }

    func format() -> String {
        if type == "Chart" {
            return "\(value)"
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .positional

        var elapsed = Date().timeIntervalSince(self.created)

        if elapsed > 0 {
            return formatter.string(from: TimeInterval(elapsed))!
        } else {
            elapsed *= -1
            return formatter.string(from: TimeInterval(elapsed))!
        }
    }

    static func fromJson(countdown: JSON, context: NSManagedObjectContext) -> Entity {
        let entity = Entity(context: context)

        let dateParser = DateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateParser.timeZone = TimeZone(abbreviation: "UTC")

        entity.id = countdown["id"].stringValue
        entity.type = "Countdown"
        entity.label = countdown["label"].stringValue
        entity.more = countdown["more"].stringValue
        entity.created = jsonDate(countdown["created"].stringValue)
        entity.detail = countdown["description"].stringValue
        entity.image = countdown["icon"].stringValue

        return entity
    }

    static func fromJson(chart: JSON, context: NSManagedObjectContext) -> Entity {
        let entity = Entity(context: context)

        entity.id = chart["id"].stringValue
        entity.type = "Chart"
        entity.label = chart["label"].stringValue
        entity.value = chart["value"].doubleValue
        entity.more = chart["more"].stringValue
        entity.detail = chart["unit"].stringValue
        entity.created = jsonDate(chart["created"].stringValue)
        entity.image = chart["icon"].stringValue

        return entity
    }

    static func jsonDate(_ string: String) -> Date {
        let dateParser = ISO8601DateFormatter()
        dateParser.formatOptions = .withInternetDateTime
        if let date = dateParser.date(from: string) {
            return date
        }
        let split = string.components(separatedBy: ".")
        print("Attemping to parse without milliseconds \(split)")
        if let date = dateParser.date(from: split[0] + "Z") {
            return date
        }
        print("Unable to parse date \(string)")
        return Date()
    }
}
