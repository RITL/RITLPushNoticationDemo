//
//  NotificationViewController.m
//  NoticationContentExtension
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface RITLNotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation RITLNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any required interface initialization here.
}


// 收到推送消息后进行的回调
- (void)didReceiveNotification:(UNNotification *)notification
{
//    self.label.text = notification.request.content.body;
    
    //
    self.label.text = @"I am label‘s text";
    
    
}



#pragma mark - <UNNotificationContentExtension>

// 推送消息得到点击响应
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
{
    NSUInteger i = 0;
}

@end
