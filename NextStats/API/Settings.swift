//
//  Settings.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

struct ApplicationSettingsKeys {
    static let apiKey = "apiKey"
    static let baseURL = "baseURL"
    static let suiteName = "group.net.kungfudiscomonkey.simplestats"
    static let username = "username"
    static let password = "password"
    static let pinned = "pinned"
    static let reverseDNS = "co.tsundere.simplestats"
}

struct ApplicationSettings {
    static let defaults = UserDefaults(suiteName: ApplicationSettingsKeys.suiteName)!

    static var baseURL: String {
        get { return defaults.string(forKey: ApplicationSettingsKeys.baseURL) ?? "https://tsundere.co/"}
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.baseURL) }
    }

    static var username: String? {
        get { return defaults.string(forKey: ApplicationSettingsKeys.username) }
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.username) }
    }

    static var password: String? {
        get { return defaults.string(forKey: ApplicationSettingsKeys.password) }
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.password) }
    }

    static var pinnedWidgets: [String] {
        get { return defaults.stringArray(forKey: ApplicationSettingsKeys.pinned) ?? [String]() }
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.pinned) }
    }

    static var cachedWidgets: [Widget] {
        get {
            guard let data = defaults.value(forKey: "cache") as? Data else {return [Widget]()}
            guard let widgets = try? PropertyListDecoder().decode([Widget].self, from: data) else {return [Widget]()}
            return widgets
        }
        set {
            defaults.set(try? PropertyListEncoder().encode(newValue), forKey: "cache")
        }
    }

    static var shortDateTime: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.locale = NSLocale.current
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        dateFormat.timeZone = TimeZone.current
        return dateFormat
    }

    static var shortTime: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
}
