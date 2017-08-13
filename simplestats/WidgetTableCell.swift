//
//  WidgetTableCell.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/21.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import SDWebImage

class WidgetTableCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelExtra: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var entity: Entity?

    func update(_ entity: Entity) {
        self.entity = entity
        let strokeTextAttributes: [String: Any] = [
            NSStrokeColorAttributeName: UIColor.white,
            NSForegroundColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -4.0
            ]

        self.labelTitle.attributedText = NSAttributedString(string: entity.label, attributes: strokeTextAttributes)
        self.labelDetail.attributedText = NSAttributedString(string: entity.format(), attributes: strokeTextAttributes)
        self.labelExtra.attributedText = NSAttributedString(string: entity.detail, attributes: strokeTextAttributes)
        self.layer.cornerRadius = 12
        self.imageView.layer.cornerRadius = 12

        self.layer.borderWidth = 4
        self.layer.borderColor = entity.pinned ? entity.color.cgColor : entity.color.withAlphaComponent(0.5).cgColor

        self.labelTitle.layer.borderWidth = entity.link == nil ? 0 : 3
        self.labelTitle.layer.borderColor = self.layer.borderColor
        if let imageURL = entity.icon {
            self.imageView.isHidden = false
            self.imageView.sd_setImage(with: imageURL)
        } else {
            self.imageView.isHidden = true
        }
    }
}
