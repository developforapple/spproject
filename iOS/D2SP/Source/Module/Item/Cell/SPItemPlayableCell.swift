//
//  SPItemPlayableCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit

class SPItemPlayableCell: UICollectionViewCell {

    @IBOutlet weak var playIndicator: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let image = UIImage.init(named: "icon_play")?.withRenderingMode(.alwaysTemplate)
        playIndicator.image = image
        playIndicator.tintColor = UIColor.white
    }
}
