//
//  API.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation

func authedRequest(url: URL, method: String, body: Data?, username: String, password: String, completionHandler: @escaping (HTTPURLResponse, Data) -> Void) {
    var request = URLRequest(url: url)

    let loginString = "\(username):\(password)"
    guard let loginData = loginString.data(using: String.Encoding.utf8) else {
        return
    }
    let base64LoginString = loginData.base64EncodedString()
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpMethod = method
    request.httpBody = body

    let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, _ -> Void in
        if let httpResponse = response as? HTTPURLResponse {
            completionHandler(httpResponse, data!)
        }
    })

    task.resume()
}

func checkLogin(username: String, password: String, completionHandler: @escaping (HTTPURLResponse) -> Void) {
    let url = URL.init(string: "\(ApplicationSettings.baseURL)api/pomodoro")!
    authedRequest(url: url, method: "GET", body: nil, username: username, password: password, completionHandler: {response, _ in
        completionHandler(response)
    })
}
