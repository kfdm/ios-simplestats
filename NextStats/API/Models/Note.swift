//
//  Note.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/17.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

struct Note: Codable {
    let timestamp: Date
    let title: String
    let description: String
}

struct NoteResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Note]
}

extension Note {
    static func list(for widget: Widget, limit: Int = 100, completionHandler: @escaping ([Note]) -> Void ) {
        guard let user = ApplicationSettings.username else { return }
        guard let pass = ApplicationSettings.password else { return }

        var query = URLComponents(url: ApplicationSettings.baseURL.appendingPathComponent("/api/widget/\(widget.slug)/notes"), resolvingAgainstBaseURL: true)
        query?.queryItems = [URLQueryItem(name: "limit", value: String(limit))]

        guard let url = query?.url else { return }

        authedRequest(url: url, method: "GET", body: nil, username: user, password: pass, completionHandler: {_, data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(dateDecode)
                do {
                    let notes = try decoder.decode(NoteResponse.self, from: data)
                    completionHandler(notes.results)
                } catch let error {
                    print(error)
                }
            }
        })
    }
}
