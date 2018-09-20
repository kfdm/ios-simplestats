//
//  WidgetCollectionCell.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class WidgetCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!

    var widget: Widget?
    var pinned = ApplicationSettings.pinnedWidgets

    override func prepareForReuse() {
        super.prepareForReuse()
        self.icon.sd_cancelCurrentImageLoad()
        self.icon.image = nil
    }

    func setImage(url: URL?, placeholder: String) {
        if let icon = url {
            self.icon.sd_setImage(with: icon, placeholderImage: UIImage(named: placeholder), options: SDWebImageOptions.scaleDownLargeImages, progress: nil, completed: nil)
        } else {
            self.icon.image = UIImage(named: placeholder)
        }
    }

    func update(widget: Widget) {
        self.widget = widget
        self.titleLabel.text = widget.title
        self.valueLabel.text = widget.formatted()
        self.valueLabel.textColor = widget.colored()
        self.valueLabel.adjustsFontSizeToFitWidth = true

        self.valueLabel.adjustsFontSizeToFitWidth = true

        switch widget.type {
        case .countdown:
            self.setImage(url: widget.icon, placeholder: "TypeCountdown")
        case .location:
            self.setImage(url: widget.icon, placeholder: "TypeLocation")
        case .chart:
            self.setImage(url: widget.icon, placeholder: "TypeChart")
        }

        // Thicker weight for pinned items
        self.layer.borderWidth = pinned.contains(widget.slug) ? 3 : 1
    }
}
