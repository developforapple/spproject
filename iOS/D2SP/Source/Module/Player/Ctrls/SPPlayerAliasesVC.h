//
//  SPPlayerAliasesVC.h
//  D2SP
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPPlayerAliase;

@interface SPPlayerAliasesVC : YGBaseTableViewCtrl

@property (strong, nonatomic) NSArray<SPPlayerAliase *> *aliasesList;

@end
