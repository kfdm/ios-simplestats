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

@objc(Entity)
public class Entity: NSManagedObject {
    func color() -> UIColor {
        let elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            return UIColor.red
        } else {
            return UIColor.green
        }
    }

    func link () -> URL? {
        return URL(string: more)
    }
}
