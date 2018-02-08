//
//  Widget.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/09.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

struct WidgetRequest: Codable {
    let results: [Widget]
}

struct Widget: Codable {
    let owner, slug: String
    let purplePublic: Bool
    let more, title: String
    let value: Int
    let description, timestamp, icon, type: String

    enum CodingKeys: String, CodingKey {
        case owner, slug
        case purplePublic = "public"
        case more, title, value, description, timestamp, icon, type
    }
}

// MARK: Convenience initializers

extension WidgetRequest {
    init(data: Data) throws {
        self = try JSONDecoder().decode(WidgetRequest.self, from: data)
    }
}

class API {
    static func fetchWidgets() -> Observable<[Widget]> {
        let token = ApplicationSettings.apiKey!
        let url = URL(string: "https://tsundere.co/api/widget")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        return session.rx.data(request: request)
            .map { try WidgetRequest(data: $0).results }
    }
}

func fetchToken(username: String, password: String, completionHandler: @escaping (String?) -> Void) {
    let parameters: Parameters = ["username": username, "password": password]

    Alamofire.request(ApplicationSettings.tokenApi, method: .post, parameters: parameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
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


func fetchWidget(token: String, completionHandler: @escaping ([JSON]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.widgetAPI, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print(json)
                completionHandler(json["results"].arrayValue)
            case .failure(let error):
                print(error)
            }
    }
}

func fetchCountdown(token: String, completionHandler: @escaping ([JSON]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.countdownAPI, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                completionHandler(json["results"].arrayValue)
            case .failure(let error):
                print(error)
            }
    }
}

func fetchChart(token: String, completionHandler: @escaping ([JSON]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.chartApi, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                completionHandler(json["results"].arrayValue)
            case .failure(let error):
                print(error)
            }
    }
}
