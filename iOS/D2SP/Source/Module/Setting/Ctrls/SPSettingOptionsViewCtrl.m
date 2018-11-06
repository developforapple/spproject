//
//  SPSettingOptionsViewCtrl.m
//  D2SP
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPSettingOptionsViewCtrl.h"
#import "SPConfigManager.h"
@import AVOSCloud;
@import TACMessaging;

@interface SPSettingOptionsViewCtrl ()
@property (weak, nonatomic) IBOutlet UISwitch *apnsSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *autoPriceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *extraInfoSwitch;

@end

@implementation SPSettingOptionsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVInstallation *i = [AVInstallation currentInstallation];
    BOOL deviceTokenValid = i.deviceToken.length > 0;
    BOOL on = [[i objectForKey:@"On"] boolValue];
    self.apnsSwitch.on = deviceTokenValid && on;
    
    self.autoPriceSwitch.on = Config.sp_config_item_detail_load_price_auto;
    self.extraInfoSwitch.on = Config.sp_config_item_detail_load_extra_data_auto;
}

- (IBAction)apnsOn:(id)sender
{
    if ([TACMessagingService defaultService].token) {
        [[TACMessagingService defaultService] stopReceiveNotifications];
    } else {
        [[TACMessagingService defaultService] deviceNotificationIsAllowed:^(BOOL isAllowed) {
            if (isAllowed) {
                [[TACMessagingService defaultService] startReceiveNotifications];
            } else {
                [SVProgressHUD showErrorWithStatus:@"请打开系统推送开关"];
                self.apnsSwitch.on = NO;
            }
        }];
    }
}

- (IBAction)autoPriceOn:(id)sender
{
    Config.sp_config_item_detail_load_price_auto = self.autoPriceSwitch.on;
}

- (IBAction)extraInfoOn:(id)sender
{
    Config.sp_config_item_detail_load_extra_data_auto = self.extraInfoSwitch.on;
}

@end
