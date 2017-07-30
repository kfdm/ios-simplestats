//
//  Widget.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/09.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol Widget {
    var id: String { get set }
    var label: String { get set }
    var more: URL? { get set }
    var created: Date { get set }
    var description: String { get set }

    func format() -> String
    func color() -> UIColor
}

class Chart: Widget {
    var id: String
    var label: String
    var more: URL?
    var created: Date
    var value: Double
    var description = ""

    init(_ json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        self.value = json["value"].doubleValue
        self.more = URL(string: json["more"].stringValue)
        self.created = dateFormatter.date(from: json["created"].stringValue)!
    }

    func format() -> String {
        return "\(self.value)"
    }

    func color() -> UIColor {
        return UIColor.cyan
    }
}

class Countdown: Widget {
    var id: String
    var label: String
    var more: URL?
    var created: Date
    var description: String

    init(_ json: JSON) {
        let dateParser = DateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateParser.timeZone = TimeZone(abbreviation: "UTC")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current

        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        self.more = URL(string: json["more"].stringValue)
        self.created = dateParser.date(from: json["created"].stringValue)!
        self.description = dateFormatter.string(from: self.created)
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
            return formattedString + " since "
        } else {
            elapsed *= -1
            let formattedString = formatter.string(from: TimeInterval(elapsed))!
            return formattedString + " until "
        }
    }

    func color() -> UIColor {
        let elapsed = Date().timeIntervalSince(self.created)
        if elapsed > 0 {
            return UIColor.red
        } else {
            return UIColor.green
        }
    }
}

func fetchWidgets() -> [Widget] {
    var widgets = [Widget]()

    if let url = URL(string: ApplicationSettings.countdownAPI) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data: data)
            for result in json["results"].arrayValue {
                widgets.append(Countdown(result))
            }
        }
    }
    widgets.sort { $0.created < $1.created }

    if let url = URL(string: ApplicationSettings.chartApi) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data: data)
            for result in json["results"].arrayValue {
                widgets.append(Chart(result))
            }
        }
    }
    return widgets
}

func fetchToken(username: String, password: String, completionHandler: @escaping (String?) -> Void) {
    let parameters: Parameters = ["username": username, "password": password]

    Alamofire.request(ApplicationSettings.tokenApi, method: .post, parameters: parameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                completionHandler(json["token"].stringValue)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
    }
}

func fetchCountdown(token: String, completionHandler: @escaping ([Widget]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.countdownAPI, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
            var widgets = [Widget]()
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                for result in json["results"].arrayValue {
                    widgets.append(Countdown(result))
                }
                completionHandler(widgets)
            case .failure(let error):
                print(error)
                completionHandler(widgets)
            }
    }
}

func fetchChart(token: String, completionHandler: @escaping ([Widget]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.chartApi, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
            var widgets = [Widget]()
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                for result in json["results"].arrayValue {
                    widgets.append(Chart(result))
                }
                completionHandler(widgets)
            case .failure(let error):
                print(error)
                completionHandler(widgets)
            }
    }
}
