//
//  ViewController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import UIKit

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var data: [Widget]?

    // MARK: - collectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WidgetCollectionCell
        if let widget = self.data?[indexPath.row] {
            cell.update(widget: widget)
        }
        return cell
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

    // MARK: - lifecycle

    override func viewDidLoad() {
        if ApplicationSettings.username == nil {
            self.performSegue(withIdentifier: "ShowLogin", sender: self)
        }
        super.viewDidLoad()
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - data

    @objc func refreshData() {
        if ApplicationSettings.username != nil {
            StatsAPI.getWidgets(completionHandler: { widgets in
                self.data = widgets.sorted(by: { $0.timestamp > $1.timestamp })
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        }
    }
}
