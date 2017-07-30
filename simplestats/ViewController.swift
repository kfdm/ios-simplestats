//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import CoreData

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var widgets = [Entity]()
    var refresh = true
    var apikey: String?
    var timer = Timer()
    var pinnedItems = [String]()
    var container: NSPersistentContainer!

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

    func loadSavedData() {
        let request = Entity.createFetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sort]

        do {
            widgets = try container.viewContext.fetch(request)
            print("Got \(widgets.count) commits")
            collectionView?.reloadData()
        } catch {
            print("Fetch failed")
        }
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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target:self, action: #selector(longpress)))

        container = NSPersistentContainer(name: "Model")

        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        pinnedItems = ApplicationSettings.pinnedItems
        performSelector(inBackground: #selector(fetchWidgets), with: nil)
        loadSavedData()
    }

    func fetchWidgets() {
        fetchCountdown(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            for widget in widgets {
                let entity = Entity(context: self.container.viewContext)
                entity.id = widget.id
                entity.label = widget.label
                entity.created = widget.created
                entity.detail = widget.description
                entity.type = "Countdown"
            }
            self.saveContext()
            self.loadSavedData()
        }

        fetchChart(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            for widget in widgets {
                let entity = Entity(context: self.container.viewContext)
                entity.id = widget.id
                entity.label = widget.label
                entity.created = widget.created
                entity.detail = widget.format()
                entity.type = "Chart"
            }
            self.saveContext()
            self.loadSavedData()
        }
    }

    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
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
