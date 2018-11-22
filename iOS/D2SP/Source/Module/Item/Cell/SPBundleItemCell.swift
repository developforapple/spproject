//
//  SPBundleItemCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit

class SPBundleItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var moreItemsView: UIView!

    var isMoreStyle = false {
        didSet {
            moreItemsView.isHidden = !isMoreStyle
        }
    }

    var item: SPItem! {
        didSet {
            SPItemImageLoader.loadItemImage(item, size: kNonePlaceholderSize, type: .normal, imageView: itemImageView)
            itemNameLabel.text = item.nameWithQualtity()
            contentView.backgroundColor = item.itemColor()
        }
    }
}
