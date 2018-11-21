//
//  SPItemEntranceCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit

class SPItemEntranceCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    private(set) var unit: SPItemEntranceUnit!

    func configure(unit: SPItemEntranceUnit) {

    }

    func configure(event: SPDotaEvent) {

    }
}
