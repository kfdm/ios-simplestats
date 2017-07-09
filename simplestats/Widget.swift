//
//  Widget.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/09.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//


import UIKit



class Widget {
    var label: String
    var description: String
    var value: String
    var more: String
    var created: Date?
    
    init(label: String, description: String, value: String, created: String, more: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        self.label = label
        self.description = description
        self.value = value
        self.created = dateFormatter.date(from: created)
        self.more = more
    }
    
    func format() -> String {
        return self.description
    }
}

class Chart: Widget {
    override func format() -> String {
        return self.value
    }
}

class Countdown: Widget {
    override func format() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .positional

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"

        if self.created != nil {
            var elapsed = Date().timeIntervalSince(self.created!)
            if elapsed > 0 {
                let formattedString = formatter.string(from: TimeInterval(elapsed))!
                return formattedString + " since " + dateFormatter.string(from: self.created!)
            } else {
                elapsed = elapsed * -1
                let formattedString = formatter.string(from: TimeInterval(elapsed))!
                return formattedString + " until " + dateFormatter.string(from: self.created!)
            }
        } else {
            return self.description
        }
    }
}
