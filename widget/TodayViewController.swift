//
//  TodayViewController.swift
//  widget
//
//  Created by ST20638 on 2017/07/11.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding, NSFetchedResultsControllerDelegate {
    var container: PersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<Entity>!
    var timer = Timer()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = widget.label
        cell.detailTextLabel?.text = widget.detail
        cell.accessoryType = widget.more == "" ? .none : .detailButton
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let widget = fetchedResultsController.object(at: indexPath)
        if let url = widget.link() {
            extensionContext?.open(url, completionHandler: nil)
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func updateCounter() {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container = PersistentContainer(name: "Model")

        container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        loadSavedData()
    }

    func loadSavedData() {
        print("loadSavedData")
        if fetchedResultsController == nil {
            let request = Entity.createFetchRequest()
            let sort = NSSortDescriptor(key: "created", ascending: false)
            request.predicate = NSPredicate(format: "pinned == 1")
            request.sortDescriptors = [sort]

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        do {
            try fetchedResultsController.performFetch()
            tableView?.reloadData()
        } catch {
            print("Fetch failed")
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
        loadSavedData()
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
