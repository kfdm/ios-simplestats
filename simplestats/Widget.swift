//
//  Widget.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/09.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import SwiftyJSON
import Alamofire

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

func fetchCountdown(token: String, completionHandler: @escaping ([JSON]) -> Void) {
    let parameters: Parameters = [:]
    let headers = ["Authorization": "Token \(token)"]
    Alamofire.request(ApplicationSettings.countdownAPI, method: .get, parameters: parameters, headers:headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
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
        .responseData { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                completionHandler(json["results"].arrayValue)
            case .failure(let error):
                print(error)
            }
    }
}
