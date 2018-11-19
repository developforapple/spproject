//
//  SPMaxPlusAPI.h
//  D2SP
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

@import Foundation;

// MAX +
@interface SPMaxPlusAPI : NSObject

+ (instancetype)shared;

/**
 *  搜索用户
 *
 *  @param keywords   关键词
 *  @param completion 回调
 *
 *  @return 搜索任务
 */
- (NSURLSessionDataTask *)searchUser:(NSString *)keywords
                          completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion;

@end
