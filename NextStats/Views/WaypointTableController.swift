//
//  WaypointTableController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/17.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class WaypointTableController: UITableViewController {
    var waypoints = [Waypoint]()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let parent = tabBarController as? DetailController else { return }
        guard let widget = parent.widget else { return }
        Waypoint.list(for: widget, limit: 500) { (waypoints) in
            self.waypoints = waypoints.sorted { $0.timestamp > $1.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - tableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypoints.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaypointTableCell", for: indexPath)
        let waypoint = waypoints[indexPath.row]

        cell.textLabel?.text = waypoint.state
        cell.detailTextLabel?.text = waypoint.description

        return cell
    }
}
