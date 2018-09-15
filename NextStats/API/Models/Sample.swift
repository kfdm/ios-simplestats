//
//  Sample.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/15.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

struct Sample: Codable {
    let timestamp: Date
    let value: Double
}

struct SampleResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Sample]
}

extension Sample {
    static func list(for widget: Widget, completionHandler: @escaping ([Sample]) -> Void ) {
        guard let user = ApplicationSettings.username else { return }
        guard let pass = ApplicationSettings.password else { return }

        var query = URLComponents(url: ApplicationSettings.baseURL.appendingPathComponent("/api/widget/\(widget.slug)/stats"), resolvingAgainstBaseURL: true)
        query?.queryItems = [URLQueryItem(name: "limit", value: "100")]

        guard let url = query?.url else { return }

        authedRequest(url: url, method: "GET", body: nil, username: user, password: pass, completionHandler:  {_, data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(dateDecode)
                do {
                    let samples = try decoder.decode(SampleResponse.self, from: data)
                    completionHandler(samples.results)
                } catch let error {
                    print(error)
                }
            }
        })
    }
}
