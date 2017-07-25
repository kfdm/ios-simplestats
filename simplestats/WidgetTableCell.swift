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


    var widget :Widget?


    func update(_ widget: Widget) {
        self.widget = widget
        self.labelTitle.text = widget.label
        self.labelDetail.text = widget.format()
        self.labelExtra.text = widget.description
        self.backgroundColor = widget.color()

        self.pinnedButton.isHidden = !ApplicationSettings.pinnedItems.contains(widget.id)
        self.moreButton.isHidden = widget.more == nil
    }

}
