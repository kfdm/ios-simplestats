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

    func update(widget: Widget) {
        self.titleLabel.text = widget.title

        if let icon = widget.icon {
            self.icon.sd_setImage(with: icon, placeholderImage: nil, options: SDWebImageOptions.scaleDownLargeImages, completed: nil)
        }

        switch widget.type {
        case "countdown":
            let formatter = ApplicationSettings.shortDateTime
            self.valueLabel.text = formatter.string(for: widget.timestamp)
            self.valueLabel.adjustsFontSizeToFitWidth = true
        default:
            print(widget.type)
            self.valueLabel.text = "\(widget.value)"
            self.valueLabel.adjustsFontSizeToFitWidth = true
        }

        self.layer.borderWidth = 1
    }
}
