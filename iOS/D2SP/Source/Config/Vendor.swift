//
//  Vendor.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation

#if TAGET_SPAd
/// 359826224@qq.com 刀塔饰品Ad
let leanCloudAppId = "K1mtJOrizsvrywTyYq85j3xL-gzGzoHsz"
let leanCloudAppKey = "6VNgktNuzuT7exKg1fTF8x4q"
#elseif TARGET_SPPro
/// 359826224@qq.com 刀塔饰品Pro
let leanCloudAppId = "nyAIoo7OddnRAE0Ch7WOTjRx-gzGzoHsz"
let leanCloudAppKey = "IVLqzHqTqdjbXch8YekoUEdf"
#elseif TARGET_SPOld
/// developforapple@163.com 饰品总汇
let leanCloudAppId = "uy7j0G50gYzI8jOopjxUNPpT-gzGzoHsz"
let leanCloudAppKey = "RkF7f6l3KjnnOKA7jTD1YFn7"
#elseif TARGET_SPOldPro
let leanCloudAppId = ""
let leanCloudAppKey = ""
#endif

#if TARGET_SPAd || TARGET_SPOld
let admobAppId = "ca-app-pub-3317628345096940~4597769315"
let admodBannerUnitId = "ca-app-pub-3317628345096940/6074502516"
let admobRewardVideoUnitId = "ca-app-pub-3317628345096940/6527269232"
let admobLaunchADUnitId = "ca-app-pub-3317628345096940/4910935239"
#endif

#if TARGET_SPAd || TARGET_SPOld
let tencentGDTAppKey = "1106592268"
let tencentGDTLaunchPOSId = "7000325834304018"
let tencentGDTBannerPOSId = "5080728864708037"
#endif
