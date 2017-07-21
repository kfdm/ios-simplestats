//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ViewController: UITableViewController, MGSwipeTableCellDelegate, UIActionSheetDelegate {
    @IBOutlet weak var loginButton: UIButton!

    var widgets = [Widget]()
    var refresh = true
    var apikey: String?
    var countdowns = [Widget]()
    var charts = [Widget]()
    var timer = Timer()
    var pinnedItems = [String]()

    @IBAction func showLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MGSwipeTableCell
        let widget = widgets[indexPath.row]

        cell.delegate = self
        cell.textLabel!.text = widget.label
        cell.detailTextLabel!.text = widget.format()

        if pinnedItems.contains(widget.id) {
            cell.accessoryType = widget.more == nil ? .detailButton : .detailDisclosureButton
        } else {
            cell.accessoryType = widget.more == nil ? .none : .disclosureIndicator
        }

        return cell
    }

    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {

        swipeSettings.transition = MGSwipeTransition.border
        expansionSettings.buttonIndex = 0
        expansionSettings.fillOnTrigger = true

        let widget = widgets[tableView.indexPath(for: cell)!.row]

        if direction == MGSwipeDirection.leftToRight {
            expansionSettings.threshold = 2
            if pinnedItems.contains(widget.id) {
                return [
                    MGSwipeButton(title: "Unpin", backgroundColor: .red, callback: { (cell) -> Bool in
                        self.pinnedItems = self.pinnedItems.filter { $0 != widget.id }
                        ApplicationSettings.pinnedItems = self.pinnedItems
                        return true
                    })
                ]
            } else {
                return [MGSwipeButton(title: "Pin", backgroundColor: .blue) {
                    (_: MGSwipeTableCell!) -> Bool in
                    self.pinnedItems.append(widget.id)
                    ApplicationSettings.pinnedItems = self.pinnedItems
                    return true
                    }]
            }

        } else {
            expansionSettings.threshold = 1.1
            if widget.more != nil {
                return [
                    MGSwipeButton(title: "More", backgroundColor: .green, callback: { (cell) -> Bool in
                        UIApplication.shared.open(widget.more!, options: [:], completionHandler: nil)
                        return true
                    })
                ]
            }
        }
        return [MGSwipeButton]()

    }

    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }

    func swipeTableCellWillBeginSwiping(_ cell: MGSwipeTableCell) {
        refresh = false
    }

    func swipeTableCellWillEndSwiping(_ cell: MGSwipeTableCell) {
        refresh = true
    }

    func updateCounter() {
        if refresh {
            self.tableView.reloadData()
        }
    }

    func refreshWidgets() {
        self.widgets = self.countdowns
            .sorted(by: {$0.created < $1.created})
            + self.charts
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pinnedItems = ApplicationSettings.pinnedItems

        fetchCountdown(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            self.countdowns = widgets
            self.refreshWidgets()
        }

        fetchChart(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            self.charts = widgets
            self.refreshWidgets()
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
