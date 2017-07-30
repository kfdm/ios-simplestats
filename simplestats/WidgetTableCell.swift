//
//  WidgetTableCell.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/21.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class WidgetTableCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelExtra: UILabel!
    @IBOutlet weak var pinnedButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!


    var entity :Entity?


    func update(_ entity: Entity) {
        self.entity = entity
        self.labelTitle.text = entity.label
        self.labelDetail.text = entity.type == "Countdown" ? "\(entity.created)" : entity.detail
        self.labelExtra.text = entity.detail
        self.backgroundColor = entity.color()

        self.pinnedButton.isHidden = !ApplicationSettings.pinnedItems.contains(entity.id)
        self.moreButton.isHidden = entity.more == nil
    }

}
