//
//  AppDelegate.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate.h"
#import "RITLOriginPushAppDelegate+RITLNotificationManager.h"


#ifdef __IPHONE_10_0
#import "RITLOriginPushAppDelegate+RITLUserNotifications.h"
#else
#import "RITLOriginPushAppDelegate+RITLOldNotification.h"
#endif

@interface RITLOriginPushAppDelegate ()

@end

@implementation RITLOriginPushAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //注册所有的推送
    [[RITLNotificationManager sharedInstance]registerRemoteNotificationsApplication:self];

    return YES;
}



#warning 因为不想再查找控制器，所以用的最容易的alertView，iOS8之后建议使用AlertController
- (void)__showAlert:(NSString *)alert
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alert message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    [alertView show];
}

@end
