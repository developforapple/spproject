//
//  SPItemLoadingView.swift
//  D2SP
//
//  Created by bo wang on 2018/11/24.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import SVProgressHUD

class SPItemLoadingView: UIView {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var btn: UIButton!

    var itemData: SPItemSharedData! {
        didSet {
            update()
        }
    }
    private var noload = false

    override func awakeFromNib() {
        super.awakeFromNib()

        /// TODO: <#something#>
//        if (Config.sp_config_item_detail_show_loading_tips) {
//            self.descLabel.text = @"正在抓取数据，点击查看详情";
//        }else{
//            self.descLabel.text = nil;
//        }
    }

    func update() {
        /// TODO: <#something#>
//        if (Config.sp_config_item_detail_load_extra_data_auto) {
//            [self ovserveExtraData];
//        }else{
//            self.noload = YES;
//            [self updateLoadingView];
//        }
    }

    func ovserveExtraData()  {
        /// TODO: <#something#>
//        self.noload = NO;
//        ygweakify(self);
//        [RACObserve(self.itemData, extraData)
//            subscribeNext:^(id x) {
//            ygstrongify(self);
//            [self updateLoadingView];
//            }];
    }

    func updateLoadingView() {
        if noload {
            loading.stopAnimating()
            descLabel.isHidden = true
            btn.setTitle("点击获取更多内容", for: .normal)
        } else {
            loading.startAnimating()
            descLabel.isHidden = false
            btn.setTitle(nil, for: .normal)

            if let extra = itemData.extraData {
                setCollapsed(true, animated: true)
                setHidden(true, animated: true)

                if let error = extra.error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func btnAction(_ sender: Any) {
        if noload {
            itemData.loadExtraData(true)
            ovserveExtraData()
        } else {
            let alert = UIAlertController.init(title: "正在从Dota2Wiki抓取更多相关内容，请稍等", message: "应用设置中可关闭自动抓取", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .canel, handler: nil))
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
