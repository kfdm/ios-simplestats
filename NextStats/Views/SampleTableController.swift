//
//  SampleTableController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/15.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class SampleTableController: UITableViewController {
    var samples = [Sample]()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let parent = tabBarController as? DetailController else { return }
        guard let widget = parent.widget else { return }
        Sample.list(for: widget, limit: 500) { (samples) in
            self.samples = samples.sorted { $0.timestamp > $1.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - tableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleTableCell", for: indexPath)
        let sample = samples[indexPath.row]

        let formatter = ApplicationSettings.shortDateTime

        cell.textLabel?.text = formatter.string(from: sample.timestamp)
        cell.detailTextLabel?.text = String(sample.value)

        return cell
    }
}
