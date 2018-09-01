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
        if let url = widget.more {
            extensionContext?.open(url, completionHandler: nil)
        } else {
            extensionContext?.open(InternalAPI.openWidget(widget: widget), completionHandler: nil)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = data[indexPath.row]

        cell.accessoryType = widget.more == nil ? .disclosureIndicator : .detailDisclosureButton 

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

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
        }
    }

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }

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
        timer.invalidate()
        super.viewWillDisappear(animated)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        StatsAPI.getWidgets(completionHandler: {widgets in
            print("widgetPerformUpdate")
            let pinned = ApplicationSettings.pinnedWidgets
            self.data = widgets.filter { pinned.contains($0.slug) }
            completionHandler(NCUpdateResult.newData)
        })
    }
}
