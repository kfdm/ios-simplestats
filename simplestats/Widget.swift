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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        print(label)
        print(description)
        print(created)
        
        self.label = label
        self.description = description
        self.value = value
        self.created = dateFormatter.date(from: created)
        self.more = more
    }
    
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        
        if self.created != nil {
            let elapsed = Date().timeIntervalSince(self.created!)
            print(elapsed)
            return dateFormatter.string(from: self.created!)
        } else {
            return self.description
        }
    }
}
