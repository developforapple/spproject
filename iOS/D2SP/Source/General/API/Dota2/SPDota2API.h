//
//  SPDota2API.h
//  D2SP
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

@import Foundation;
#import "SPDota2MarketItem.h"

@interface SPDota2API : NSObject

+ (void)fetchDota2SpecilPriceItem:(void (^)(SPDota2SpotlightItem *item))completion;

@end
