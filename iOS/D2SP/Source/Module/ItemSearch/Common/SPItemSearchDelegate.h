//
//  SPItemSearchDelegate.h
//  D2SP
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

@import Foundation;

@class SPItemSearchViewCtrl;
@class SPItemSearchOption;

@protocol SPItemSearchDelegate <NSObject>

@required
- (NSInteger)numberOfSearchResults:(SPItemSearchViewCtrl *)vc option:(SPItemSearchOption *)option;

@optional
- (void)willDismissSearchController:(SPItemSearchViewCtrl *)vc option:(SPItemSearchOption *)option;

@end
