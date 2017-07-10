//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var widgets = [Widget]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = widgets[indexPath.row]
        cell.textLabel?.text = widget.label
        cell.detailTextLabel?.text = widget.format()
        if widget.more == nil {
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.detailButton
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if widgets[indexPath.row].more != nil {
            UIApplication.shared.open(widgets[indexPath.row].more!, options: [:], completionHandler: nil)
        }
    }

    func updateCounter() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        let countdownApi = "https://tsundere.co/api/countdown"

        if let url = URL(string: countdownApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    widgets.append(Countdown(result))
                }
            }
        }

        let chartApi = "https://tsundere.co/api/chart"

        if let url = URL(string: chartApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    widgets.append(Chart(result))
                }
            }
        }

        tableView.reloadData()
    }

}
