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
    let defaults = UserDefaults(suiteName: "group.net.kungfudiscomonkey.simplestats")!

    @IBAction func showLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MGSwipeTableCell
        let widget = widgets[indexPath.row]
        var pinnedItems = defaults.array(forKey: "pinned")  as? [String] ?? [String]()

        cell.delegate = self
        cell.textLabel!.text = widget.label
        cell.detailTextLabel!.text = widget.format()

        cell.rightButtons = [MGSwipeButton]()

        if pinnedItems.contains(widget.id) {
            cell.rightButtons.append(MGSwipeButton(title: "Unpin", backgroundColor: .red) {
                (_: MGSwipeTableCell!) -> Bool in
                pinnedItems = pinnedItems.filter { $0 != widget.id }
                self.defaults.set(pinnedItems, forKey: "pinned")
                return true
            })
        } else {
            cell.rightButtons.append(MGSwipeButton(title: "Pin", backgroundColor: .blue) {
                (_: MGSwipeTableCell!) -> Bool in
                pinnedItems.append(widget.id)
                self.defaults.set(pinnedItems, forKey: "pinned")
                return true
            })
        }

        if widget.more != nil {
            cell.rightButtons.append(MGSwipeButton(title: "More", backgroundColor: .lightGray) {
                (_: MGSwipeTableCell!) -> Bool in
                if widget.more != nil {
                    UIApplication.shared.open(widget.more!, options: [:], completionHandler: nil)
                }
                return true
            })
        }

        cell.rightSwipeSettings.transition = .border

        if pinnedItems.contains(widget.id) {
            if widget.more == nil {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .detailDisclosureButton
            }
        } else {
            if widget.more == nil {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .detailButton
            }
        }

        return cell
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

    override func viewDidLoad() {
        super.viewDidLoad()
        apikey = defaults.string(forKey: "apikey")

        var _ = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )

        self.loginButton.isHidden = apikey != nil

        widgets = fetchWidgets()
        tableView.reloadData()
    }

}
