//
//  SPItemSteamPriceCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SDWebImage
import YYCategories

class SPItemSteamPriceCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemQtyLabel: UILabel!
    @IBOutlet weak var itemPriceBtn: UIButton!

    var itemPrice: SPMarketItem!

    func configure(_ itemPrice: SPMarketItem) {
        self.itemPrice = itemPrice

        itemImageView.sd_setImage(with: URL.init(string: itemPrice.image))
        itemNameLabel.text = itemPrice.name
        itemQtyLabel.text = "x \(itemPrice.qty!)"
        itemPriceBtn.setTitle(itemPrice.price, for: .normal)
    }

    @IBAction func steamWebsiteAction(_ sender: AnyObject) {
        if var components = URLComponents.init(string: itemPrice.href) {
            components.queryItems = nil
            if let url = components.url {
                SPWebHelper.open(url, from: self.viewController!)
            }
        }

    }
    
}
