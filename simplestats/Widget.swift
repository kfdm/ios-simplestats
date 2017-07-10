//
//  Widget.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/09.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit

protocol Widget {
    var label: String { get set }
    var more: URL? { get set }
    var created: Date { get set }
    var description: String { get set }

    func format() -> String
}

class Chart: Widget {
    var label: String
    var more: URL?
    var created: Date
    var value: Double
    var description = ""

    init(_ json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        self.label = json["label"].stringValue
        self.value = json["value"].doubleValue
        self.more = URL(string: json["more"].stringValue)
        self.created = dateFormatter.date(from: json["created"].stringValue)!
    }

    func format() -> String {
        return "\(self.value)"
    }
}

class Countdown: Widget {
    var label: String
    var more: URL?
    var created: Date
    var description: String

    init(_ json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        self.label = json["label"].stringValue
        self.description = json["description"].stringValue
        self.more = URL(string: json["more"].stringValue)
        self.created = dateFormatter.date(from: json["created"].stringValue)!
    }

    func format() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .positional

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current

        var elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            let formattedString = formatter.string(from: TimeInterval(elapsed))!
            return formattedString + " since " + dateFormatter.string(from: self.created)
        } else {
            elapsed = elapsed * -1
            let formattedString = formatter.string(from: TimeInterval(elapsed))!
            return formattedString + " until " + dateFormatter.string(from: self.created)
        }
    }
}
