//
//  Widget.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/15.
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

extension Widget {
    static func list(completionHandler: @escaping ([Widget]) -> Void) {
        guard let user = ApplicationSettings.username else { return }
        guard let pass = ApplicationSettings.password else { return }

        var query = URLComponents.init(url: ApplicationSettings.baseURL.appendingPathComponent("/api/widget"), resolvingAgainstBaseURL: true)
        query?.queryItems = [URLQueryItem(name: "limit", value: "100")]

        guard let url = query?.url else { return }

        authedRequest(url: url, method: "GET", body: nil, username: user, password: pass, completionHandler:  {_, data in
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

    func localURL() -> URL {
        return URL(string: "\(ApplicationSettingsKeys.reverseDNS)://open/\(self.slug)")!
    }
}
