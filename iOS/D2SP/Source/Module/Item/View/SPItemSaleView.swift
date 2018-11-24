//
//  SPItemSaleView.swift
//  D2SP
//
//  Created by bo wang on 2018/11/24.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import ChameleonFramework
import ReactiveObjC

enum SPItemPlatform {
    case dota2
    case steam
    case taobao
}

class SPItemPlatformView: YGLineView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var platform: SPItemPlatform!
    var item: SPItem!
    var isNoload = false

    func noload() {
        isNoload = true
        errorLabel.isHidden = true
        loading.stopAnimating()
        btn.setTitle("点击获取价格", for: .normal)
    }

    func update(price priceObject: SPItemPriceBase?) {
        isNoload = false

        if let price = priceObject {
            loading.stopAnimating()
            let isFailed = price.error.count > 0
            errorLabel.text = price.error
            errorLabel.isHidden = !isFailed
            btn.isHidden = isFailed

            switch platform! {
            case .dota2:
                if let d2Price = price as? SPItemDota2Price {
                    if !isFailed {
                        btn.setTitle(d2Price.price, for: .normal)
                    }
                }
            case .steam:
                if let steamPrice = price as? SPItemSteamPrice {
                    if !isFailed {
                        btn.setTitle(steamPrice.basePrice(), for: .normal)
                    }
                }
            case .taobao: break
            }
        } else {
            loading.startAnimating()
            btn.isHidden = true
            errorLabel.isHidden = true
        }
    }
}

class SPItemSaleView: UIView {

    @IBOutlet weak var dota2View: SPItemPlatformView?
    @IBOutlet weak var steamView: SPItemPlatformView?
    @IBOutlet weak var taobaoView: SPItemPlatformView?

    var itemData: SPItemSharedData! {
        didSet {
            dota2View?.item = itemData.item
            steamView?.item = itemData.item
            taobaoView?.item = itemData.item

            updateDota2Price(forced: false)
            updateSteamPrice(forced: false)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dota2View?.platform = .dota2
        steamView?.platform = .steam
        taobaoView?.platform = .taobao

        dota2View?.btn.isUserInteractionEnabled = false
        steamView?.btn.isUserInteractionEnabled = false
        taobaoView?.btn.isUserInteractionEnabled = false
    }

    func updateDota2Price(forced: Bool) {
        /// TODO: <#something#>
//        if ( forced || Config.sp_config_item_detail_load_price_auto) {
//            ygweakify(self);
//            [RACObserve(self.itemData, dota2Price)
//                subscribeNext:^(id x) {
//                ygstrongify(self);
//                [self.dota2View updatePrice:self.itemData.dota2Price];
//                }];
//        }else{
//            [self.dota2View noload];
//        }
    }

    func updateSteamPrice(forced: Bool) {
        /// TODO: <#something#>
//        if (forced || Config.sp_config_item_detail_load_price_auto) {
//            ygweakify(self);
//            [RACObserve(self.itemData, steamPrice)
//                subscribeNext:^(id x) {
//                ygstrongify(self);
//                [self.steamView updatePrice:self.itemData.steamPrice];
//                }];
//        }else{
//            [self.steamView noload];
//        }
    }

    @IBAction func bgAction(_ sender: UIView) {
        /// TODO: <#something#>
//        if ([self.dota2View containView:bg]) {
//            if (self.dota2View.isNoload) {
//                [self.itemData loadDota2Price:YES];
//                [self updateDota2Price:YES];
//            }else{
//                BOOL failed = self.itemData.dota2Price.error.length;
//                if (failed) {
//                    [SVProgressHUD showInfoWithStatus:self.itemData.dota2Price.error];
//                }else{
//                    [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item dota2MarketURL]] from:self.viewController.navigationController];
//                }
//            }
//        }else if ([self.steamView containView:bg]){
//            if (self.steamView.isNoload) {
//                [self.itemData loadSteamPrice:YES];
//                [self updateSteamPrice:YES];
//            }else{
//                BOOL failed = self.itemData.steamPrice.error.length;
//                if (failed) {
//                    [SVProgressHUD showInfoWithStatus:self.itemData.steamPrice.error];
//                }else{
//                    SPItemSteamPricesViewCtrl *vc = [SPItemSteamPricesViewCtrl instanceFromStoryboard];
//                    vc.item = self.itemData.item;
//                    [self.viewController.navigationController pushViewController:vc animated:YES];
//                }
//            }
//        }
    }

    @IBAction func btnAction(_ btn: UIButton) {
        /// TODO: <#something#>
//        if ([self.dota2View containView:btn]) {
//            if (self.dota2View.isNoload) {
//                [self.itemData loadDota2Price:YES];
//                [self updateDota2Price:YES];
//            }else{
//                BOOL failed = self.itemData.dota2Price.error.length;
//                if (failed) {
//                    [SVProgressHUD showInfoWithStatus:self.itemData.dota2Price.error];
//                }else{
//                    [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item dota2MarketURL]] from:self.viewController.navigationController];
//                }
//            }
//        }else if ([self.steamView containView:btn]){
//            if (self.steamView.isNoload) {
//                [self.itemData loadSteamPrice:YES];
//                [self updateSteamPrice:YES];
//            }else{
//                BOOL failed = self.itemData.steamPrice.error.length;
//                if (failed) {
//                    [SVProgressHUD showInfoWithStatus:self.itemData.steamPrice.error];
//                }else{
//                    [SPWebHelper openURL:[NSURL URLWithString:[self.itemData.item steamMarketURL]] from:self.viewController.navigationController];
//                }
//            }
//        }
    }

}
