//
//  SPItemViewCtrl.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import MXParallaxHeader
import ReactiveObjC

class SPItemViewCtrl: YGBaseViewCtrl {

    var item: SPItem?
    var playerItem: SPPlayerItemDetail?

    private lazy var itemData: SPItemSharedData = {
        let data = SPItemSharedData.init(item: item)!
        data.playerItem = playerItem
        return data
    }()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var bannerPanel: SPItemBannerView!
    @IBOutlet weak var titlePanel: SPItemTitleView!
    @IBOutlet weak var salePanel: SPItemSaleView!
    @IBOutlet weak var loadingView: SPItemLoadingView!
    @IBOutlet weak var descPanel: SPItemDescPanel!
    @IBOutlet weak var playablePanel: SPItemPlayableView!
    @IBOutlet weak var moreItemsPanel: SPItemMoreItemsView!
    @IBOutlet weak var starBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        updateUI()
        addToHistory()
    }

    private func initUI() {
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = automaticallyAdjustsScrollViewInsets ? .automatic : .never
        }

        scrollView.parallaxHeader.delegate = self
        scrollView.parallaxHeader.view = bannerPanel
        if is_iPad {
            scrollView.parallaxHeader.height = CGFloat(device_width) * 2.0 / 4.0
        } else {
            scrollView.parallaxHeader.height = CGFloat(device_width) * 2.0 / 3.0
        }
        scrollView.parallaxHeader.mode = .fill
        scrollView.parallaxHeader.minimumHeight = 20
    }

    private func updateUI() {
        bannerPanel.itemData = itemData
        titlePanel.itemData = itemData
        salePanel.itemData = itemData
        loadingView.itemData = itemData
        playablePanel.itemData = itemData
        moreItemsPanel.itemData = itemData
        descPanel.itemData = itemData


        let signal = itemData.rac_values(forKeyPath: #keyPath(SPItemSharedData.starred), observer: self)
        signal.subscribeNext { [weak self] (x) in
            self?.starBtn.isSelected = (x as! NSNumber).boolValue
        }
    }

    private func addToHistory() {
        SPHistoryManager.shared()?.add(itemData.item.token.stringValue)
    }

    @IBAction func starBtnAction(_ sender: AnyObject) {
        if itemData.starred {
            SPStarManager.shared()?.remove(itemData.item.token.stringValue)
        } else {
            SPStarManager.shared()?.add(itemData.item.token.stringValue)
        }
        itemData.starred.toggle()
    }
}

extension SPItemViewCtrl: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        bannerPanel.scrollProgress = Float(parallaxHeader.progress)
    }
}
