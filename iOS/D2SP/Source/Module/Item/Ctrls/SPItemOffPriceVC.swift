//
//  SPItemOffPriceVC.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import WebKit

class SPItemOffPriceVC: YGBaseViewCtrl, WKNavigationDelegate {

    var webView: WKWebView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView.init(frame: view.bounds)
        webView.backgroundColor = UIColor.black
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.sendSubviewToBack(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.VFL(["V:|-0-[view]-0-|", "H:|-0-[view]-0-|"], ["view": webView])

        loadIndicator.startAnimating()

        let url = URL.init(string: "http://event.dota2.com.cn/dota2/featured/index/?appinstall=0")!
        let request = URLRequest.init(url: url,
                                      cachePolicy: .reloadIgnoringLocalCacheData,
                                      timeoutInterval: 60)
        webView.load(request)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadIndicator.stopAnimating()
    }
}
