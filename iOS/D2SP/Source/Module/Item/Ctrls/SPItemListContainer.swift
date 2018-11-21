//
//  SPItemListContainer.swift
//  D2SP
//
//  Created by bo wang on 2018/11/21.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

@objc protocol SPItemListContainerDelegate: NSObjectProtocol {
    @objc func containerWillLoadMore(_ container: SPItemListContainer)
    @objc func container(_ container: SPItemListContainer, didSelected item: SPItem)
}

let kSPItemListModeAuto = 10086

class SPItemListContainer: YGBaseViewCtrl {

    weak var delegate: SPItemListContainerDelegate?
    var supportLoadMore = false
    var emptyDataNote: NSAttributedString?
    var safeInset = UIEdgeInsets.zero

    private(set) var items: [SPItem] = []
    private(set) var mode: SPItemListMode = .table

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowlayout: UICollectionViewFlowLayout!

    private var cellModels: [SPItemCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollsToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView.scrollsToTop = false
    }

    func update(mode: SPItemListMode, data: [SPItem]? = nil)  {
        if let items = data {
            self.items = items
        }
        self.mode = mode
        self.cellModels = (0..<self.items.count).map({ (idx) -> SPItemCellModel in
            let item = self.items[idx]
            let cellModel = SPItemCellModel.init(entity: item)!
            cellModel.mode = mode
            cellModel.lineHidden = idx % 4 == 0
            cellModel.create()
            return cellModel
        })
        setupLayout(UIScreen.main.bounds.size)
        collectionView.endFooterRefreshing()
        collectionView.reloadData()
    }

    func setupClearBackground() {
        view.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
    }

    func append(data: [SPItem]?) {
        guard let items = data, items.count > 0 else {
            collectionView.endFooterRefreshing()
            return
        }

        let cellModels = (0..<items.count).map { (idx) -> SPItemCellModel in
            let item = items[idx]
            let cm = SPItemCellModel.init(entity: item)!
            cm.mode = self.mode
            cm.lineHidden = idx % 4 == 0
            cm.create()
            return cm
        }
        self.cellModels.append(contentsOf: cellModels)
        self.items.append(contentsOf: items)
        collectionView.endFooterRefreshing()
        collectionView.reloadData()
    }
}

private extension SPItemListContainer {
    func initUI() {
        SPLogoHeader.setLogoHeaderIn(collectionView)
        if supportLoadMore {
            collectionView.refreshDelegate = self
            collectionView.refreshFooterEnable = true
        }
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.contentInset = safeInset

        if #available(iOS 10, *) {
            collectionView.prefetchDataSource = self
        }
        setupLayout(UIScreen.main.bounds.size)
    }

    func setupLayout(_ size: CGSize)  {
        let layout = createItemLayout(mode, size)
        flowlayout.itemSize = layout.itemSize
        flowlayout.sectionInset = layout.sectionInset
        flowlayout.minimumInteritemSpacing = CGFloat(layout.interitemSpacing)
        flowlayout.minimumLineSpacing = CGFloat(layout.lineSpacing)
    }
}

extension SPItemListContainer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = mode == .grid ? R.reuseIdentifier.spItemCellNormal : R.reuseIdentifier.spItemCellLarge
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)!
        cell.preload(cellModels[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! SPItemCell).willDisplay()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sel = #selector(SPItemListContainerDelegate.container(_:didSelected:))
        if let d = delegate, d.responds(to: sel) {
            d.container(self, didSelected: items[indexPath.item])
        } else {
            if let vc = SPItemsDetailViewCtrl.sb.create() {
                vc.item = items[indexPath.item]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        DispatchQueue.global().async {
            let urls = indexPaths.compactMap({ self.items[$0.item].qiniuSmallURL() })
            SPItemImageLoader.prefetchItemImages(urls)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // 啥都不做
    }
}

extension SPItemListContainer: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let label = emptyDataNote {
            return label
        }
        return NSAttributedString.init(string: "没有内容", attributes: [.font: UIFont.systemFont(ofSize: 20)])
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return items.count == 0
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension SPItemListContainer: UINavigationControllerDelegate {}

extension SPItemListContainer: YGRefreshDelegate {
    func refreshFooterBeginRefreshing(_ scrollView: UIScrollView!) {
        let sel = #selector(SPItemListContainerDelegate.containerWillLoadMore(_:))
        if let d = delegate, d.responds(to: sel) {
            d.containerWillLoadMore(self)
        }
    }
}
