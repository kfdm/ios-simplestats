//
//  ApplicationSettings.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/21.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import Foundation

struct ApplicationSettingsKeys {
    static let apiKey = "apiKey"
    static let suiteName = "group.net.kungfudiscomonkey.simplestats"
    static let pinnedKey = "pinned"
}

struct ApplicationSettings {
    static let defaults = UserDefaults(suiteName: ApplicationSettingsKeys.suiteName)!
    static let baseURL = "https://tsundere.co"
    static let countdownAPI = "https://tsundere.co/api/countdown"
    static let tokenApi = "https://tsundere.co/api/token/"
    static let chartApi = "https://tsundere.co/api/chart"

    static var apiKey: String? {
        get { return defaults.string(forKey: ApplicationSettingsKeys.apiKey) }
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.apiKey) }
    }

    static var pinnedItems: [String] {
        get { return defaults.array(forKey: ApplicationSettingsKeys.pinnedKey)  as? [String] ?? [String]() }
        set { defaults.set(newValue, forKey: ApplicationSettingsKeys.pinnedKey) }
    }
}
