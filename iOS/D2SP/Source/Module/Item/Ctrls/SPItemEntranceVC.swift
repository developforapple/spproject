//
//  SPItemEntranceVC.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SDWebImage.SDImageCache

class SPItemEntranceVC: YGBaseViewCtrl {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!

    private var config: SPItemEntranceConfig!

    private lazy var loadOnce: () -> Void = {
        let after = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: after, execute: {
            self.collectionView.setHidden(false, animated: true)
            self.loading.stopAnimating()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared().clearMemory()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadOnce()
    }

    private func initUI() {
        setupLayout(UIScreen.main.bounds.size)
        SPLogoHeader.setLogoHeaderIn(collectionView)
    }

    private func setupLayout(_ size: CGSize) {
        let itemPerLine: CGFloat = is_iPad ? (is_landscape ? 4.0 : 3.0) : 2.0
        let itemW = (size.width - 0.5 * (itemPerLine - 1)) / itemPerLine
        let itemH = itemW
        flowlayout.itemSize = CGSize(width: itemW, height: itemH)
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 0
    }

    override func transitionLayout(to size: CGSize) {
        setupLayout(size)
        collectionView.setCollectionViewLayout(flowlayout, animated: false)
    }

    private func loadConfigure() {
        config = SPItemEntranceConfig.init()
        config.unitDidUpdated = { [weak self] unit in
            self?.didUpdate(unit: unit!)
        }
        config.beginUpdateAuto()
    }

    private func didUpdate(unit: SPItemEntranceUnit) {
        if let index = config.units.firstIndex(of: unit) {
            let indexPath = IndexPath.init(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    private func showItems(_ query: SPItemQuery) {
        if let vc = SPItemListVC.sb.create() {
            vc.query = query
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SPItemEntranceVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return config.units.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.spItemEntranceCell, for: indexPath)!
        cell.configure(unit: config.units[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let unit = config.units[indexPath.item]

        switch unit.type {
        case .offPrice:
            var url = URL.init(string: unit.href)
            if url == nil {
                let str = "http://dota2.com/store/?random=\(Int.random(in: 0..<10000))"
                url = URL.init(string: str)
            }
            SPWebHelper.open(url, from: self)
        case .heroItem:
            SPItemHeroPickerVC.bePushing(in: navigationController) { [weak self] (hero) -> Bool in
                let query = SPItemQuery.init(hero: hero)
                self?.showItems(query!)
                return false
            }
        case .event:
            if let vc = SPDotaEventsViewCtrl.sb.create() {
                navigationController?.pushViewController(vc, animated: true)
            }
        case .courier: fallthrough
        case .world: fallthrough
        case .hud: fallthrough
        case .audio: fallthrough
        case .treasureBundle: fallthrough
        case .league: fallthrough
        case .other:
            if SPDataManager.isDataValid() {
                let prefabs = SPDataManager.shared()?.prefabs(of: unit.type)
                let query = SPItemQuery.init(perfabs: prefabs)
                query?.queryTitle = unit.title
                showItems(query!)
            } else {
                /// FIXME: 数据不完整
//                [UIAlertController alert:@"数据不完整" message:@"请关闭应用后重试"];
            }
        case .onSale:
            let urlStr = "http://dota2.com/store/?random=\(Int.random(in: 0..<10000))"
            let url = URL.init(string: urlStr)
            SPWebHelper.open(url, from: self)
        case .market:
            let url = URL.init(string: "http://steamcommunity.com/market/search?appid=570")
            SPWebHelper.open(url, from: self)
        }
    }
}
