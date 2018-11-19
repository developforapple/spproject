//
//  SPFilterGroup.h
//  D2SP
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

@import Foundation;

@class SPFilterUnit;

@interface SPFilterGroup : NSObject

@property (strong, nonatomic) NSArray<SPFilterUnit *> *units;

@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) NSString *footerTitle;

- (void)insertUnit:(SPFilterUnit *)unit atIndex:(NSInteger)index;
- (void)addUnit:(SPFilterUnit *)unit;
- (void)removeUnit:(SPFilterUnit *)unit;
- (void)resetUnits:(NSArray *)units;
- (void)moveUnit:(SPFilterUnit *)unit toIndex:(NSInteger)index;

@end
