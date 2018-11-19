//
//  AppDelegate.swift
//  D2SP
//
//  Created by bo wang on 2018/11/5.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation
import ChameleonFramework
import SVProgressHUD
import SDWebImage
import AVOSCloud

#if TARGET_SPAd || TARGET_SPOld
import GoogleMobileAds
#endif

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate {

    @objc static var instance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        setupBackupSettiing()
        setupUIAppearance()
        setup3rdParty()
        checkAppDeploy()

        return true
    }

    private func setupUIAppearance() {
        let item = UIBarButtonItem.appearance()
        item.tintColor = UIColor.white
        item.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 16)], for: .normal)
        item.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 16)], for: .highlighted)
        item.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 16)], for: .selected)
        if #available(iOS 11, *) {} else {
            item.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: CGFloat(Int.min), vertical: -65), for: .default)
        }

        let navi = UINavigationBar.appearance()
        navi.backIndicatorImage = nil
        navi.backIndicatorTransitionMaskImage = nil
        navi.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18)]

        UISegmentedControl.appearance().tintColor = UIColor.white

        UIViewController.defaultStatusBarStyle = .lightContent
        UIViewController.setDefaultNavigationBarTintColor(UIColor.flatNavyBlue())
        UIViewController.setDefaultNavigationBarLineHidden(true)
        UIViewController.setDefaultNavigationBarTextColor(UIColor.white)
        UIViewController.statusBarControlMode = .auto

        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)

        SDWebImageDownloader.shared().downloadTimeout = 60
    }

    private func setupBackupSettiing() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = NSURL.init(fileURLWithPath: documents)
        try? url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
    }

    private func checkAppDeploy() {
        SPDeploy.instance()?.update()
    }

    private func setup3rdParty() {
        setupTAC()

        SPItemImageLoader.setSDWebImageUseYYMemoryCache()
        SDWebImageManager.shared().imageDownloader?.maxConcurrentDownloads = 20
        SDWebImagePrefetcher.shared().maxConcurrentDownloads = 4
        SDWebImagePrefetcher.shared().prefetcherQueue = DispatchQueue.init(label: "SDWebImagePrefetcherQueue", attributes: .concurrent)

        SPLogger.logger.setup()

        #if TARGET_SPAd || TARGET_SPOld
        GADMobileAds.configure(withApplicationID: admobAppId)
        #endif

        AVOSCloud.setApplicationId(leanCloudAppId, clientKey: leanCloudAppKey)
    }

    @objc func uploadPushToken() {
        /// TODO:  需要绑定 token
    }
}
