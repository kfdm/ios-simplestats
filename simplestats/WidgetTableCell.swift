//
//  WidgetTableCell.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/21.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit

class WidgetTableCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelExtra: UILabel!

    var entity: Entity?

    func update(_ entity: Entity) {
        self.entity = entity
        self.labelTitle.text = entity.label
        self.labelDetail.text = entity.format()
        self.labelExtra.text = entity.detail
        self.backgroundColor = entity.color

        self.layer.borderWidth = 4
        self.layer.borderColor = entity.pinned ? UIColor.black.cgColor : UIColor.lightGray.cgColor

        self.labelTitle.layer.borderWidth = entity.link == nil ? 0 : 3
        self.labelTitle.layer.borderColor = self.layer.borderColor
    }
}
