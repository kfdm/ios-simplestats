//
//  DetailViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Widget!

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style> body { font-size: 150%; } </style>"
            html += "</head>"
            html += "<body>"
            html += detailItem.description
            html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
    }
}
