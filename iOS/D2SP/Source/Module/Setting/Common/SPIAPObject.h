//
//  SPIAPObject.h
//  D2SP
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

@import AVOSCloud;
@import StoreKit;

@interface SPIAPObject : AVObject

+ (void)saveTransaction:(SKPaymentTransaction *)transaction;
+ (void)saveTransaction:(SKPaymentTransaction *)transaction verification:(NSString *)response;

@end
