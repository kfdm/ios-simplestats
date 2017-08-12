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

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Entity>!
    var apikey: String?
    var timer = Timer()

    var container: PersistentContainer!

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WidgetTableCell
        let widget = fetchedResultsController.object(at: indexPath)
        cell.update(widget)
        cell.layer.cornerRadius = 11
        return cell
    }

    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Entity.createFetchRequest()
            let sort = NSSortDescriptor(key: "created", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        //fetchedResultsController.fetchRequest.predicate = commitPredicate

        do {
            try fetchedResultsController.performFetch()
            collectionView?.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    fileprivate let itemsPerRow: CGFloat = 3

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         // 10 Gives us our border around the edges
        let width = (UIScreen.main.bounds.width - 10) / 3

        if width > 128 {
            return CGSize(width: 128, height: 128)
        }
        return CGSize(width: width, height: width)
    }

    func updateCounter() {
        self.collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target:self, action: #selector(longpress)))
        collectionView?.refreshControl = UIRefreshControl()
        collectionView?.refreshControl?.addTarget(self, action: #selector(fetchWidgets), for: UIControlEvents.valueChanged)

        container = PersistentContainer(name: "Model")

        container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        performSelector(inBackground: #selector(fetchWidgets), with: nil)
        loadSavedData()
    }

    func fetchWidgets() {
        fetchCountdown(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            for widget in widgets {
                _ = Entity.fromJson(countdown: widget, context: self.container.viewContext)
            }
            self.saveContext()
            self.loadSavedData()
            self.collectionView?.refreshControl?.endRefreshing()
        }

        fetchChart(token: ApplicationSettings.apiKey ?? "") {
            (widgets) -> Void in
            for widget in widgets {
                _ = Entity.fromJson(chart: widget, context: self.container.viewContext)
            }
            self.saveContext()
            self.loadSavedData()
            self.collectionView?.refreshControl?.endRefreshing()
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

    func tap(sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            let widget = fetchedResultsController.object(at: indexPath)
            if let url = widget.link {
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
            let widget = fetchedResultsController.object(at: indexPath)
            widget.pinned = !widget.pinned
            print("Setting widget to \(widget.pinned)")
            self.saveContext()
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
