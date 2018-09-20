//
//  DetailController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class DetailController: UITabBarController, Storyboarded {
    weak var coordinator: MainCoordinator?

    var widget: Widget?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let widget = widget else {
            return
        }
        print("The Widget is: \(widget)")
    }
}
