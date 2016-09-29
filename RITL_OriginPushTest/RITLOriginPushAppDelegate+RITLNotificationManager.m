//
//  RITLOriginPushAppDelegate+RITLNotifaicationManager.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate+RITLNotificationManager.h"
#import "RITLPushCategoryManager.h"


@implementation RITLOriginPushAppDelegate (RITLNotificationManager)

// 注册推送成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    NSLog(@"token = %@",deviceToken);
    // 将返回的token发送给服务器
}

// 注册推送失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remoteNotice failture = %@",error.localizedDescription);
}

@end













@implementation RITLNotificationManager

+(instancetype)sharedInstance
{
    static RITLNotificationManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [self new];
    });
    
    return manager;
}



#ifdef __IPHONE_10_0
-(void)registerRemoteNotificationsApplication:(id<UNUserNotificationCenterDelegate>)application
#else
- (void)registerRemoteNotificationsApplication:(id)application
#endif
{
#ifdef __IPHONE_10_0
    
    
#ifdef ShouldAddDefaultCategorys
    
    [RITLPushCategoryManager addDefaultCategorys];
    
#endif

    //设置代理对象
    [UNUserNotificationCenter currentNotificationCenter].delegate = application;
    
    // 请求权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted == true)//如果准许，注册推送
        {
            [[UIApplication sharedApplication]registerForRemoteNotifications];
        }
        
    }];

#else
    
#ifdef __IPHONE_8_0 //适配iOS 8
    
#ifdef ShouldAddDefaultCategorysBeforeiOS10
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObjects:[RITLPushCategoryManager addDefaultCategorysBeforeiOS10], nil]]];
#else
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    
#endif
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
#else //适配iOS7
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
#endif
    
#endif
}

@end
