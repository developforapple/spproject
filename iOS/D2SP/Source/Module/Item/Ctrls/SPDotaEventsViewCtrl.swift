//
//  SPDotaEventsViewCtrl.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit

class SPDotaEventsViewCtrl: YGBaseViewCtrl {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!

    private var events: [SPDotaEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        events = SPDataManager.shared()!.events
        initUI()
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
}

extension SPDotaEventsViewCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.spItemEntranceCell, for: indexPath)!
        cell.configure(event: events[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard SPDataManager.isDataValid() else {
            /// FIXME:
//             [UIAlertController alert:@"数据不完整" message:@"请关闭应用后重试"];
            return
        }
        let event = events[indexPath.item]
        let query = SPItemQuery.init(event: event)
        query?.queryTitle = event.name_loc
        if let vc = SPItemListVC.sb.create() {
            vc.query = query
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
