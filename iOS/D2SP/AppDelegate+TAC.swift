//
//  AppDelegate+TAC.swift
//  D2SP
//
//  Created by bo wang on 2018/11/4.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation
import TACCore
import TACCrash
import TACMessaging
import TACStorage
import FCUUID
import CocoaLumberjack

#if TARGET_SPAd || TARGET_SPOld
import AdSupport
#endif

extension AppDelegate {
    @objc func setupTAC()  {
        let options = TACApplicationOptions.default()!

        // Analytics
        let analytics = options.analyticsOptions!
        #if DEBUG
        analytics.strategy = .instant
        #else
        analytics.strategy = .batch
        #endif

        #if TARGET_SPAd || TARGET_SPOld
        analytics.idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        #endif

        // APNS
        let messaging = options.messagingOptions!
        messaging.autoStart = SPDataManager.isDataValid()
        TACMessagingService.default()?.delegate = self

        // Crash
        let crash = options.crashOptions!
        crash.channel = "App Store"
        crash.deviceIdentifier = FCUUID.uuidForDevice()

        // Storage
        let storage = options.storageOptions!
//        TACStorageService.defaultStorage()?.credentailFenceQueue.delegate = self

        // Setup
        TACApplication.configurate(with: options)
        TACApplication.default()?.bindUserIdentifier(FCUUID.uuidForDevice())

        // Log
        DDLogInfo(analytics.logInfo)
        DDLogInfo(messaging.logInfo)
        DDLogInfo(crash.logInfo)
        DDLogInfo(storage.logInfo)
    }
}

extension AppDelegate: TACMessagingDelegate {
    public func messagingDidFinishStart(_ isSuccess: Bool, error: Error?) {
        DDLogInfo("messagingDidFinishStart Success: \(isSuccess), error: \(error?.localizedDescription ?? "null")", tag: "TAC")
    }

    public func messagingDidFinishStop(_ isSuccess: Bool, error: Error?) {
        DDLogInfo("messagingDidFinishStop Success: \(isSuccess), error: \(error?.localizedDescription ?? "null")")
    }

    public func messagingDidReportNotification(_ isSuccess: Bool, error: Error?) {
        DDLogInfo("messagingDidReportNotification Success: \(isSuccess), error: \(error?.localizedDescription ?? "null")")
    }

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((UNNotificationPresentationOptions) -> Void)!) {
        DDLogInfo("收到推送通知(UN): \(notification.request.content.userInfo)")
        completionHandler([.badge, .alert, .sound])
    }

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        DDLogInfo("收到推送通知 Response: \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        DDLogInfo("收到推送通知：\(userInfo)")
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = String.init(format: "%@", deviceToken as CVarArg)
        DDLogInfo("注册 APNS 成功，DeviceToken: \(token))")
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DDLogInfo("注册 APNS 失败，Error: \(error.localizedDescription)")
    }
}

private var credential: QCloudCredential = {
    let c = QCloudCredential.init()
    c.secretID = "AKIDpW2JK6i2D9qIVS6j37wWrwmNmyubmFBs"
    c.secretKey = "auyoPkqgGagYBZicHgpkPq2yf8SZR3QX"
    return c
}()

extension AppDelegate: QCloudCredentailFenceQueueDelegate {
    public func fenceQueue(_ queue: QCloudCredentailFenceQueue!, requestCreatorWithContinue continueBlock: QCloudCredentailFenceQueueContinue!) {
        let creator = QCloudAuthentationCreator.init(credential: credential)
        continueBlock(creator, nil)
    }
}

private extension TACAnalyticsOptions {
    var logInfo: String {
        return """
        [TACAnalyticsOptions]:
        - appKey: \(appKey ?? "null")
        - strategy: \(strategy)
        - minBatchReportCount: \(minBatchReportCount)
        - sendPeriodMillis: \(sendPeriodMillis)
        - sessionTimeoutMillis: \(sessionTimeoutMillis)
        - autoTrackPageEvents: \(autoTrackPageEvents)
        - smartReporting: \(smartReporting)
        - channelUrl: \(channelUrl ?? "null")
        - enable: \(enable)
        - idfa: \(idfa ?? "null")
        """
    }
}

private extension TACMessagingOptions {
    var logInfo: String {
        return """
        [TACMessagingOptions]:
        - appId: \(appId)
        - appKey: \(appKey ?? "null")
        - autoStart: \(autoStart)
        """
    }
}

private extension TACCrashOptions {
    var logInfo: String {
        return """
        [TACCrashOptions]:
        - appId: \(appId ?? "null")
        - excludeModuleFilters: \(excludeModuleFilters ?? [])
        - enable: \(enable)
        - channel: \(channel ?? "null")
        - version: \(version ?? "null")
        - deviceIdentifier: \(deviceIdentifier ?? "null")
        - blockMonitorEnable: \(blockMonitorEnable)
        - blockMonitorTimeout: \(blockMonitorTimeout)
        - applicationGroupIdentifier: \(applicationGroupIdentifier ?? "null")
        - symbolicateInProcessEnable: \(symbolicateInProcessEnable)
        - unexpectedTerminatingDetectionEnable: \(unexpectedTerminatingDetectionEnable)
        - viewControllerTrackingEnable: \(viewControllerTrackingEnable)
        - excludeModuleFilter: \(excludeModuleFilter ?? [])
        - consolelogEnable: \(consolelogEnable)
        """
    }
}

private extension TACStorageOptions {
    var logInfo: String {
        return """
        [TACStorageOptions]:
        - bucket: \(bucket ?? "null")
        - region: \(region ?? "null")
        - appId: \(appId ?? "null")
        """
    }
}
