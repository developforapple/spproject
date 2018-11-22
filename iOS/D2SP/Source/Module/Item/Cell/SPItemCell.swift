//
//  SPItemCell.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import QuartzCore

class SPItemCell: UICollectionViewCell {

    @IBOutlet weak var backColorView: UIView?
    @IBOutlet weak var itemImageView: UIImageView?
    @IBOutlet weak var itemNameLabel: UILabel?
    @IBOutlet weak var itemRarityLabel: UILabel?
    @IBOutlet weak var itemTypeLabel: UILabel?
    @IBOutlet weak var leftLine: YGLineView?

    var model: SPItemCellModel!

    private var placeholderImageLayer: CALayer?
    private var imageLayer: CALayer?
    private var nameLayer: CATextLayer?
    private var gLayer: CAGradientLayer?

    func preload(_ cellModel: SPItemCellModel)  {
        model = cellModel
        switch cellModel.mode {
        case .grid:
            if imageLayer == nil {
                createImageLayer()
            }
            if nameLayer == nil {
                createNameLayer()
            }
            contentView.backgroundColor = cellModel.item()?.itemColor()
        case .table:
            if gLayer == nil {
                createGLayer()
            }
        }
        leftLine?.isHidden = model.lineHidden
    }

    func willDisplay() {
        let data = model.entity!

        if let item = data as? SPPlayerItemDetail {
            loadInventoryItem(item)
            return
        }

        if let item = data as? SPItem {
            if itemImageView != nil {
                SPItemImageLoader.loadItemImage(item, size: model.preferImageSize, type: .normal, imageView: itemImageView!)
            } else {
                SPItemImageLoader.loadItemImage(item, size: kNonePlaceholderSize, type: .normal, layer: imageLayer)
            }

            if let layer = nameLayer {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.bounds = CGRect(origin: .zero, size: CGSize(width: model.nameSize.width - 4.0, height: model.nameSize.height))
                layer.position = model.namePosition
                layer.string = model.name
                layer.backgroundColor = contentView.backgroundColor?.cgColor
                CATransaction.commit()
            }

            if let label = itemNameLabel {
                label.text = item.nameWithQualtity()
            }

            if let label = itemTypeLabel {
                label.text = model.typeString
            }

            if let label = itemRarityLabel {
                label.text = model.rarityString
            }

            if model.mode == .table {
                gLayer?.colors = model.gradientColors
            }
        }
    }

    func display() {

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLayer?.contents = nil
        imageLayer?.isHidden = true
    }

    private func createImageLayer() {
        let layer = CALayer.init()
        layer.frame = CGRect(origin: .zero, size: model.preferImageSize)
        layer.contentsScale = screen_scale
        layer.contentsGravity = .resizeAspectFill
        layer.masksToBounds = true
        layer.isOpaque = true
        layer.opacity = 1
        layer.drawsAsynchronously = true
        layer.isHidden = true
        contentView.layer.insertSublayer(layer, at: 0)
        imageLayer = layer
    }

    private func createNameLayer() {
        let layer = CATextLayer.init()
        layer.isWrapped = true
        layer.truncationMode = .none
        layer.alignmentMode = .center
        layer.contentsScale = screen_scale
        layer.masksToBounds = true
        contentView.layer.insertSublayer(layer, above: imageLayer)
        nameLayer = layer
    }

    private func createGLayer() {
        guard let bcv = backColorView else { return }
        let layer = CAGradientLayer.init()
        layer.frame = CGRect(origin: .zero, size: CGSize(width: CGFloat(device_width), height: bcv.bounds.height))
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.locations = [0, 1]
        bcv.layer.addSublayer(layer)
        gLayer = layer
    }

    private func loadInventoryItem(_ itemDetail: SPPlayerItemDetail)  {
        let rarityTag = itemDetail.rarityTag()
        itemNameLabel?.text = itemDetail.name
        itemRarityLabel?.text = rarityTag?.name
        itemTypeLabel?.text = itemDetail.type
        itemNameLabel?.textColor = UIColor.white
        itemRarityLabel?.textColor = UIColor.white
        itemTypeLabel?.textColor = UIColor.white

        if model.mode == .grid, let tagColor = rarityTag?.tagColor.color {
            itemNameLabel?.backgroundColor = blendColors(UIColor.white, tagColor, 0.5)
        }
    }
}
