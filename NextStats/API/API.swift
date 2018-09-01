//
//  API.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

struct Widget: Codable {
    let owner: String
    let slug: String
    let timestamp: Date
    let title: String
    let description: String
    let icon: URL?
    let value: Double
    let more: URL?
    let type: String
    let publicWidget: Bool

    private enum CodingKeys: String, CodingKey {
        case owner
        case slug
        case timestamp
        case title
        case description
        case icon
        case value
        case more
        case type
        case publicWidget = "public"
    }
}

struct WidgetResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Widget]
}

func authRequest(username: String, password: String, url: URL, completionHandler: @escaping (HTTPURLResponse, Data) -> Void) {
    var request = URLRequest.init(url: url)

    let loginString = "\(username):\(password)"

    guard let loginData = loginString.data(using: String.Encoding.utf8) else {
        return
    }
    let base64LoginString = loginData.base64EncodedString()

    request.httpMethod = "GET"
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, _ -> Void in
        if let httpResponse = response as? HTTPURLResponse {
            completionHandler(httpResponse, data!)
        }
    })

    task.resume()
}

func postRequest(postBody: Data, method: String, url: URL, completionHandler: @escaping (HTTPURLResponse, Data) -> Void) {
    let username = ApplicationSettings.username!
    let password = ApplicationSettings.password!
    var request = URLRequest(url: url)

    let loginString = "\(username):\(password)"

    guard let loginData = loginString.data(using: String.Encoding.utf8) else {
        return
    }
    let base64LoginString = loginData.base64EncodedString()

    request.httpMethod = method
    request.httpBody = postBody
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, _ -> Void in
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse)
            completionHandler(httpResponse, data!)
        }
    })

    task.resume()
}

class StatsURL {
    static func wigetURL() -> URL {
        return URL(string: "\(ApplicationSettings.baseURL)api/widget?limit=100")!
    }
}

class InternalAPI {
    static func openWidget(widget: Widget) -> URL {
        return URL(string: "\(ApplicationSettingsKeys.reverseDNS)://open/\(widget.slug)")!
    }
}

class StatsAPI {
    static func getWidgets(completionHandler: @escaping ([Widget]) -> Void) {
        guard let user = ApplicationSettings.username else { return }
        guard let pass = ApplicationSettings.password else { return }
        authRequest(username: user, password: pass, url: StatsURL.wigetURL(), completionHandler: {_, data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(dateDecode)
                do {
                    let widgets = try decoder.decode(WidgetResponse.self, from: data)
                    completionHandler(widgets.results)
                } catch let error {
                    print(error)
                }
            }
        })
    }
}

func checkLogin(username: String, password: String, completionHandler: @escaping (HTTPURLResponse) -> Void) {
    authRequest(username: username, password: password, url: StatsURL.wigetURL(), completionHandler: {response, _ in
        completionHandler(response)
    })
}
