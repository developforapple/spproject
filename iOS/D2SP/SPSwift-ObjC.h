//
//  SPSwift.h
//  D2SP
//
//  Created by bo wang on 2018/11/5.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

#ifndef SPSwift_h
#define SPSwift_h

///
/// 提供给 Objective-C 调用的 Swift 自动生成头文件
///

#if TARGET_SPAd

#import "SPAd-Swift.h"

#elif TARGET_SPPro

#import "SPPro-Swift.h"

#elif TARGET_SPOld

#import "SPOld-Swift.h"

#elif TARGET_SPOldPro

#import "SPOldPro-Swift.h"

#endif

#endif /* SPSwift_h */
