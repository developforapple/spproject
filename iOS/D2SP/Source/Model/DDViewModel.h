//
//  DDViewModel.h
//  QuizUp
//
//  Created by Normal on 16/4/8.
//  Copyright © 2016年 zhenailab. All rights reserved.
//

@import Foundation;

/**
 *  简单的viewModel基类
 */
@interface DDViewModel : NSObject

/*!
 *  @brief 子类复写create。从而延迟创建viewModel的内容。也可以重写初始化方法，创建viewModel的内容
 */

+ (instancetype)viewModelWithEntity:(id)entity NS_REQUIRES_SUPER;
- (instancetype)initWithEntity:(id)entity NS_REQUIRES_SUPER;

@property (assign, readonly, getter=isEmpty, nonatomic) BOOL empty;
+ (instancetype)empty;

- (void)create;
- (void)update;

@property (strong, readonly, nonatomic) id entity;

/**
 *  使用于TableView时计算得出高度
 *  子类复写
 */
- (CGFloat)containerHeight;

/**
 *  使用于UICollectionViewFlowLayout时，计算得出size
 *  子类复写
 */
- (CGSize)size;

@end
