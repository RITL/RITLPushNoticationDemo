//
//  AppDelegate.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate.h"

#ifdef __IPHONE_10_0

#import "RITLOriginPushAppDelegate+RITLUserNotifications.h"
@import UserNotifications;

#endif

@interface RITLOriginPushAppDelegate ()

@end

@implementation RITLOriginPushAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
#ifdef __IPHONE_10_0
    
    //设置代理对象
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // 请求权限 
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted == true)//如果准许，注册推送
        {
            [[UIApplication sharedApplication]registerForRemoteNotifications];
        }
    
    }];
#else
    
#ifdef __IPHONE_8_0 //适配iOS 8
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
#else //iOS7 
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
#endif
#endif
    return YES;
}



// 注册推送成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //获得token
//    NSLog(@"token = %@",deviceToken);
}

// 注册推送失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remoteNotice failture = %@",error.localizedDescription);
}


//因为iOS10已经适配，预编译舍掉即可

#ifndef __IPHONE_10_0

//通过点击远程推送进入App执行的方法,不管是应用被杀死还是位于后台
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到的信息
    NSLog(@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
    
    
    [self __showAlert:@"通过点击推送进入App"];
}

// 收到本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //coding to handle local notification
    NSLog(@"本地推送啦!");
    
    [self __showAlert:@"有信息哦"];
}

#endif

// 在前台收到远程推送执行的方法,如果实现了iOS10的协议方法，该方法不执行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //对于iOS10之前进行本地推送
    UILocalNotification * localNotification = [[UILocalNotification alloc]init];
    
    //设置触发时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    //触发标志
    localNotification.applicationIconBadgeNumber = 1;
    //触发声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //设置消息体
    localNotification.alertBody = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    //注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    //回调
    completionHandler(UIBackgroundFetchResultNewData);
}




- (void)__showAlert:(NSString *)alert
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alert message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    [alertView show];
}





@end
