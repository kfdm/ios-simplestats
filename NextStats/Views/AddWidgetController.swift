//
//  AddWidgetController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/21.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import UIKit


class AddWidgetController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var widgetTitle: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}
