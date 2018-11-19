//
//  SPItemEntranceConfig.h
//  D2SP
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

@import Foundation;
#import "SPItemCommon.h"

@interface SPItemEntranceUnit : NSObject <NSCopying,NSCoding>
@property (assign, nonatomic) SPItemEntranceType type;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *defaultImage;
@property (copy, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *lastImage;
@property (copy, nonatomic) NSString *href;
@end

@interface SPItemEntranceConfig : NSObject

@property (strong, nonatomic) NSArray<SPItemEntranceUnit *> *units;
@property (copy, nonatomic) void (^unitDidUpdated)(SPItemEntranceUnit *unit);

- (SPItemEntranceUnit *)unitOfType:(SPItemEntranceType)type;

- (void)beginUpdateAuto;

@end

