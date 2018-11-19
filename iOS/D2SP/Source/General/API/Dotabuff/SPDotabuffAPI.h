//
//  SPDotabuffAPI.h
//  D2SP
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

@import Foundation;

// DotaBuff
@interface SPDotabuffAPI : NSObject

+ (void)searchUser:(NSString *)keywords
        completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion;

@end
