//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    var timer = Timer()
    var data = [Widget]()

    @objc func updateCounter() {
        self.tableView.reloadData()
    }

    // MARK: - tableview

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let widget = data[indexPath.row]
        extensionContext?.open(InternalAPI.openWidget(widget: widget), completionHandler: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        let widget = data[indexPath.row]

        switch widget.type {
        case "countdown":
            let formatter = ApplicationSettings.shortTime
            let duration = widget.timestamp.timeIntervalSinceNow

            cell.textLabel?.text = widget.title
            cell.detailTextLabel?.text = formatter.string(from: duration)
            cell.detailTextLabel?.textColor = duration > 0 ? UIColor(named: "CountdownFuture") : UIColor(named: "CountdownPast")
        case "location":
            cell.textLabel?.text = widget.title
            cell.detailTextLabel?.text = "\(widget.value)"
        case "chart":
            cell.textLabel?.text = widget.title
            cell.detailTextLabel?.text = "\(widget.value)"
        default:
            print(widget.type)
            cell.textLabel?.text = widget.title
            cell.detailTextLabel?.text = "\(widget.value)"
        }

        return cell
    }

    // MARK: - lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        StatsAPI.getWidgets(completionHandler: {widgets in
            print("widgetPerformUpdate")
            let pinned = ApplicationSettings.pinnedWidgets
            self.data = widgets.filter { pinned.contains($0.slug) }
            self.tableView.reloadData()
            completionHandler(NCUpdateResult.newData)
        })
    }
}
