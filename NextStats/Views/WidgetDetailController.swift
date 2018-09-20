//
//  WidgetDetailController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/15.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class WidgetDetailController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(barButtonSystemItem: .compose, target: nil, action: nil)
        ]
    }

    // MARK: - tableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableCell", for: indexPath)
        guard let tabBar = tabBarController as? DetailController else { return cell }
        guard let widget = tabBar.widget else { return cell }
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Title"
            cell.detailTextLabel?.text = widget.title
        case 1:
            cell.textLabel?.text = "Description"
            cell.detailTextLabel?.text = widget.description
        case 2:
            cell.textLabel?.text = "Type"
            cell.detailTextLabel?.text = String(widget.type)
        case 3:
            cell.textLabel?.text = "Value"
            cell.detailTextLabel?.text = String(widget.value)
        case 4:
            let formatter = ApplicationSettings.shortDateTime
            cell.textLabel?.text = "Date"
            cell.detailTextLabel?.text = formatter.string(from: widget.timestamp)
        case 5:
            cell.textLabel?.text = "More"
            if let more = widget.more {
                cell.detailTextLabel?.text = more.absoluteString
            }
        default:
            cell.textLabel?.text = "Unknown"
        }

        return cell
    }
}
