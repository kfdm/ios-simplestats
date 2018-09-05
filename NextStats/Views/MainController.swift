//
//  ViewController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import UIKit

final class MainController: UICollectionViewController {
    private var data = [Widget]()
    private var timer = Timer()
    private var pinned = ApplicationSettings.pinnedWidgets
    private var refreshControl: UIRefreshControl!

    static func storyboardIdentifier() -> String {
        return "MainController"
    }

    // MARK: - collectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WidgetCollectionCell
        cell.update(widget: self.data[indexPath.row])
        return cell
    }

    private let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    private let itemsPerRow: CGFloat = 3

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let cell = sender as! WidgetCollectionCell
            let destination = segue.destination as! DetailController
            destination.widget = cell.widget
        }
    }

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard Router.isLoggedIn() else {
            Router.showLogin()
            return
        }

        collectionView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longpress)))

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        collectionView!.addSubview(refreshControl)

        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - buttons

    @IBAction func organizeButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Actions", message: "Actions.", preferredStyle: .actionSheet)
        //alertController.popoverPresentationController.barButtonItem = button;
        alert.popoverPresentationController?.barButtonItem = sender
        alert.popoverPresentationController?.sourceView = collectionView

        alert.addAction(UIAlertAction(title: NSLocalizedString("Logout", comment: "Default action"), style: .destructive, handler: { _ in
            ApplicationSettings.username = nil
            ApplicationSettings.password = nil
            Router.showLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - data

    @objc func refreshData() {
        if ApplicationSettings.username != nil {
            self.refreshControl.beginRefreshing()
            StatsAPI.getWidgets(completionHandler: { widgets in
                self.data = widgets.sorted(by: { $0.timestamp > $1.timestamp })
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.collectionView?.reloadData()
                }
            })
        }
    }

    @objc func updateCounter() {
        self.collectionView?.reloadData()
    }

    func PinAction(widget: Widget) -> UIAlertAction {
        return UIAlertAction(title: "Pin", style: .default, handler: {_ in
            self.pinned.append(widget.slug)
            ApplicationSettings.pinnedWidgets = self.pinned
        })
    }

    func UnpinAction(widget: Widget) -> UIAlertAction {
        return UIAlertAction(title: "Unpin", style: .default, handler: {_ in
            self.pinned = self.pinned.filter { $0 != widget.slug }
            ApplicationSettings.pinnedWidgets = self.pinned
        })
    }

    private func alertForCell(indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as! WidgetCollectionCell
        let widget = self.data[indexPath.row]
        let alert = UIAlertController(title: "Actions", message: "Actions.", preferredStyle: .actionSheet)

        alert.popoverPresentationController?.sourceView = cell
        alert.popoverPresentationController?.permittedArrowDirections = .any
        alert.popoverPresentationController?.sourceRect = cell.bounds

        if pinned.contains(widget.slug) {
            alert.addAction(UnpinAction(widget: widget))
        } else {
            alert.addAction(PinAction(widget: widget))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @objc func longpress(sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            print(indexPath)
            alertForCell(indexPath: indexPath)
        }
    }
}

extension MainController {
    private func moveToDetailController(with widget: Widget) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailController.storyboardIdentifier()) as? DetailController else {
            return
        }
        detailViewController.widget = widget
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 10 Gives us our border around the edges
        let width = (UIScreen.main.bounds.width - 10) / 3

        if width > 128 {
            return CGSize(width: 128, height: 128)
        }
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailWidget = data[indexPath.row]
        moveToDetailController(with: detailWidget)
    }
}
