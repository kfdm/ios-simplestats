//
//  Waypoint.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/17.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

struct Waypoint: Codable {
    let timestamp: Date
    let state: String
    let lat: Double
    let lon: Double
    let description: String
}

struct WaypointResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Waypoint]
}

extension Waypoint {
    static func list(for widget: Widget, limit: Int = 100, completionHandler: @escaping ([Waypoint]) -> Void ) {
        guard let user = ApplicationSettings.username else { return }
        guard let pass = ApplicationSettings.password else { return }

        var query = URLComponents(url: ApplicationSettings.baseURL.appendingPathComponent("/api/widget/\(widget.slug)/waypoints"), resolvingAgainstBaseURL: true)
        query?.queryItems = [URLQueryItem(name: "limit", value: String(limit))]

        guard let url = query?.url else { return }

        authedRequest(url: url, method: "GET", body: nil, username: user, password: pass, completionHandler:  {_, data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(dateDecode)
                do {
                    let waypoints = try decoder.decode(WaypointResponse.self, from: data)
                    completionHandler(waypoints.results)
                } catch let error {
                    print(error)
                }
            }
        })
    }
}
