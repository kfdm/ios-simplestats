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
            extensionContext?.open(widget.localURL(), completionHandler: nil)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = data[indexPath.row]

        cell.accessoryType = widget.more == nil ? .disclosureIndicator : .detailDisclosureButton

        cell.textLabel?.text = widget.title
        cell.detailTextLabel?.text = widget.formatted()
        cell.detailTextLabel?.textColor = widget.colored()

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

        // Restore Cached State
        self.data =  ApplicationSettings.cachedWidgets
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
        Widget.list(completionHandler: {widgets in
            print("widgetPerformUpdate")
            let pinned = ApplicationSettings.pinnedWidgets
            self.data = widgets.filter { pinned.contains($0.slug) }
            ApplicationSettings.cachedWidgets = self.data
            completionHandler(NCUpdateResult.newData)
        })
    }
}
