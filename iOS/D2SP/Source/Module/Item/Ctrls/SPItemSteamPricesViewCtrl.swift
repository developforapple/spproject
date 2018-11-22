//
//  SPItemSteamPricesViewCtrl.swift
//  D2SP
//
//  Created by bo wang on 2018/11/22.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SVProgressHUD

class SPItemSteamPricesViewCtrl: YGBaseViewCtrl {

    var item: SPItem!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    private var priceList: [SPMarketItem] = []
    private var pageNo = 0
    private var inLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshHeader(false, footer: true, delegate: self)
        loadData(pageNo)
    }

    private func loadData(_ pageNo: Int) {
        SPItemPriceLoader.loadSteamMarketPriceList(item, pageNo: pageNo) { [weak self] (p) in
            if let price = p {
                self?.loading.stopAnimating()
                self?.parsePrice(price, page: pageNo)
            }
        }
    }

    private func parsePrice(_ price: SPItemSteamPrice, page: Int) {
        tableView.resetRefreshing()
        if price.error != nil {
            SVProgressHUD.showError(withStatus: price.error!)
            return
        }
        if !price.list.success || price.items.count < 10 {
            tableView.setNoMoreData()
        }
        self.pageNo = page
        priceList.append(contentsOf: price.items)
        tableView.reloadData()
    }

    override func transitionLayout(to size: CGSize) {
        tableView.reloadData()
    }
}

extension SPItemSteamPricesViewCtrl: YGRefreshDelegate {
    func refreshFooterBeginRefreshing(_ scrollView: UIScrollView!) {
        loadData(pageNo + 1)
    }
}

extension SPItemSteamPricesViewCtrl: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.spItemSteamPriceCell, for: indexPath)!
        cell.configure(priceList[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = SPPriceChartViewCtrl.sb.create() {
            vc.item = item
            vc.marketItem = priceList[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
