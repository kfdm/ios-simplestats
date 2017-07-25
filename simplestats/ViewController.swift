//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var widgets = [Widget]()
    var refresh = true
    var apikey: String?
    var countdowns = [Widget]()
    var charts = [Widget]()
    var timer = Timer()
    var pinnedItems = [String]()

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgets.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WidgetTableCell
        cell.update(widgets[indexPath.row])
        return cell
    }

    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    fileprivate let itemsPerRow: CGFloat = 3

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func updateCounter() {
        if refresh {
            self.collectionView?.reloadData()
        }
    }

    func refreshWidgets() {
        self.widgets = self.countdowns
            .sorted(by: {$0.created < $1.created})
            + self.charts
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target:self, action: #selector(longpress)))

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

    func tap(sender: UITapGestureRecognizer){
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            let widget = self.widgets[indexPath.row]
            if let url = widget.more {
                print("opening url")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("no url")
            }
        }
    }

    func longpress(sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            let widget = self.widgets[indexPath.row]
            var pinnedItems = ApplicationSettings.pinnedItems
            if pinnedItems.contains(widget.id) {
                print("Unpin")
                ApplicationSettings.pinnedItems = pinnedItems.filter { $0 != widget.id }
            } else {
                print("Pin")
                pinnedItems.append(widget.id)
                ApplicationSettings.pinnedItems = pinnedItems
            }
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
}
