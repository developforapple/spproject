//
//  DDMainTBC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainTBC.h"
#import "SPUpdateViewCtrl.h"
#import "SPResourceManager.h"
#import "SPDataManager.h"
#import "SPIAPHelper.h"
#import "SPConfigManager.h"
@import ReactiveObjC;
@import AVOSCloud;
@import StoreKit;
@import SDWebImage;

@interface DDMainTBC () <SKStoreProductViewControllerDelegate>
@property (assign, nonatomic) NSTimeInterval lastCheckTime;
@property (weak, nonatomic) SPUpdateViewCtrl *updateViewCtrl;
@end

@implementation DDMainTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self alertRateIfNeed];
}

- (void)rootViewControllerDidAppear:(UINavigationController *)navi
{
    [self checkUpdateIfNeed];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)checkUpdateIfNeed
{
    if (![SPDataManager isDataValid]) {
        _lastCheckTime = [[NSDate date] timeIntervalSince1970];
        [[SPUpdateViewCtrl instanceFromStoryboard] show];
    }else{
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        if (time - _lastCheckTime > 12*60*60 ) {
            _lastCheckTime = time;
            ygweakify(self);
            [RACObserve([SPResourceManager manager], needUpdate)
             subscribeNext:^(id  x) {
                 ygstrongify(self);
                 if (!x) {
                     return;
                 }
                 if ([x boolValue] && !self.updateViewCtrl) {
                     [self noticeNeedUpdate];
                 }
             }];
            [[SPResourceManager manager] checkUpdate];
        }
    }
}

- (void)noticeNeedUpdate
{
    [UIAlertController confirm:@"饰品数据库需要更新"
                       message:@""
                        cancel:@"取消"
                          done:@"更新"
                      callback:^(BOOL isDone) {
                          if (isDone) {
                              [self beginUpdateData];
                          }else{
                              [self addNeedUpdateBadge];
                          }
                      }];
}

- (void)beginUpdateData
{
    self.updateViewCtrl = [SPUpdateViewCtrl instanceFromStoryboard];
    [self.updateViewCtrl show];
}

- (void)addNeedUpdateBadge
{
    UITabBarItem *item = [self tabBarItemOfTab:SPTabTypeMore];
    item.badgeValue = @"1";
}

- (void)alertRateIfNeed
{
    Config.sp_config_open_counter ++;
    
    if (Config.sp_config_open_counter == 5) {
        if (iOSLater(10.3)) {
            [SKStoreReviewController requestReview];
        }else{
            [self alertWriteReviewContentIfNeed];
        }
    }else if (Config.sp_config_open_counter % 25 == 0){
        [self alertWriteReviewContentIfNeed];
    }
}

- (void)alertWriteReviewContentIfNeed
{
    if (!Config.sp_config_appstore_review_flag) {
        RunAfter(2.f, ^{
            NSString *msg = [NSString stringWithFormat:@"\n如果您觉得“%@”好用，欢迎前往AppStore发表评价。\n",AppDisplayName];
            [UIAlertController confirm:@"给个好评吧？" message:msg cancel:@"取消" redDone:@"评价" callback:^(BOOL isDone) {
                if (isDone){
                    [self openAppStore];
                }
            }];
        });
    }
}

- (void)openAppStore
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",kAppAppleID];
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) {
        Config.sp_config_appstore_review_flag = YES;
    }
}

@end
