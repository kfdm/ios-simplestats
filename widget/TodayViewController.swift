//
//  TodayViewController.swift
//  widget
//
//  Created by ST20638 on 2017/07/11.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    var widgets = [Widget]()
    var charts = [Widget]()
    var countdowns = [Widget]()
    var timer = Timer()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = widgets[indexPath.row]
        cell.textLabel?.text = widget.label
        cell.detailTextLabel?.text = widget.format() + widget.description
        cell.accessoryType = widget.more == nil ? .none : .detailButton
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = widgets[indexPath.row].more {
            extensionContext?.open(url, completionHandler: nil)
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func refresh() {
        let pinnedItems = ApplicationSettings.pinnedItems
        NSLog("Pinned items: \(pinnedItems)")
        widgets = (self.countdowns + self.charts)
            .filter { pinnedItems.contains($0.id) }
            .sorted(by: {$0.created < $1.created})
    }

    func updateCounter() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCountdown(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            self.countdowns = widgets
            self.refresh()
        }

        fetchChart(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            self.charts = widgets
            self.refresh()
        }
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
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        preferredContentSize = tableView.contentSize
    }

}
