//
//  SPItemTitleView.swift
//  D2SP
//
//  Created by bo wang on 2018/11/24.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SDWebImage
import ChameleonFramework

class SPItemTag: NSObject {
    var tag: String
    var color: UIColor

    init(tag: String, color: UIColor) {
        self.tag = tag
        self.color = color
    }
}

class SPItemTagCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!

    var tagInfo: SPItemTag! {
        didSet {
            tagLabel.text = tagInfo.tag
            tagLabel.textColor = UIColor.white
            tagLabel.textColor = tagInfo.color
            contentView.layer.borderColor = tagInfo.color.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 0.5
    }
}

class SPItemTitleView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tagView: UICollectionView!
    @IBOutlet private weak var tagViewLayout: SPLeftAlignmentLayout!
    @IBOutlet private weak var tagViewHeightConstraint: NSLayoutConstraint!

    var itemData: SPItemSharedData! {
        didSet {
            update()
        }
    }
    private var tags: [SPItemTag] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        tagViewLayout.estimatedItemSize = tagViewLayout.itemSize
        tagViewLayout.maximumInteritemSpacing = 10
    }

    private func update() {
        if let playerItem = itemData.playerItem {
            titleLabel.text = playerItem.market_name
        } else {
            titleLabel.text = itemData.item.nameWithQualtity()
        }
        subtitleLabel.text = itemData.item.enNameWithQuality()

        if let hero = itemData.hero {
            let url = URL.init(string: hero.vertImageURL())
            let placeholder = placeholderImage(imageView.bounds.size)
            imageView.sd_setImage(with: url,
                                  placeholderImage: placeholder,
                                  options: [.retryFailed, .lowPriority, .continueInBackground],
                                  completed: nil)
        } else {
            imageView.isCollapsed = true
        }

        let commonColor = UIColor.flatGrayColorDark()!
        var tags = [SPItemTag]()

        // Quality Tag
        if let playerItem = itemData.playerItem {
            let qualityName = playerItem.qualityTag()!.name!
            tags.append(SPItemTag.init(tag: qualityName, color: commonColor))
        }

        // Hero Tag
        if let hero = itemData.hero {
            tags.append(SPItemTag.init(tag: hero.name_loc, color: commonColor))
        }

        // Rarity Tag
        if let rarity = itemData.rarity {
            tags.append(SPItemTag.init(tag: rarity.name_loc, color: commonColor))
        }

        // Type Tag
        if let type = itemData.item.item_type_name {
            let tagStr = SPDataManager.shared()?.localizedString(type) ?? type
            tags.append(SPItemTag.init(tag: tagStr, color: commonColor))
        }

        // Slot Tag
        if let slot = itemData.slot {
            tags.append(SPItemTag.init(tag: slot.name_loc, color: commonColor))
        }

        // Set tag
        if let set = itemData.itemSet {
            tags.append(SPItemTag.init(tag: set.name_loc, color: commonColor))
        }

        // Event Tag
        if let event = itemData.event {
            tags.append(SPItemTag.init(tag: event.name_loc, color: commonColor))
        }

        // 可交易 Tag
        if let playerItem = itemData.playerItem {
            let tradable = playerItem.tradable.boolValue
            tags.append(SPItemTag(tag: tradable ? "可交易" : "不可交易", color: commonColor))
        }

        // 可出售 Tag
        if let playerItem = itemData.playerItem {
            let marketable = playerItem.marketable.boolValue
            tags.append(SPItemTag(tag: marketable ? "可出售" : "不可出售", color: commonColor))
        }

        self.tags = tags
        tagView.reloadData()

        let delay = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.tagViewHeightConstraint.constant = self.tagView.contentSize.height
            self.layoutIfNeeded()
        }
    }
}

extension SPItemTitleView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.spItemTagCell, for: indexPath)!
        cell.tagInfo = tags[indexPath.item]
        return cell
    }
}
