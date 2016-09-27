//
//  RITLOriginPushAppDelegate+RITLUserNotifications.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate+RITLUserNotifications.h"

@implementation RITLOriginPushAppDelegate (RITLUserNotifications)


#pragma mark - <UNUserNotificationCenterDelegate>

// 在前台收到通知时，将要弹出通知的时候触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //比如如果App实在前台，就不需要Badge了
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
    
    else//如果是后台或者不活跃状态，需要badge
    {
        //需要三种弹出形式,如果存在Alert,那么App在前台也是可以从上面弹出的
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}



// 已经收到通知响应的处理方法，不管是什么通知，当通过点击推送进入到App的时候触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    
    //获得响应对象
    UNNotification * notification = response.notification;
    
    //获得响应时间
    NSDate * responseDate = notification.date;
    
    //获得响应体
    UNNotificationRequest * request = notification.request;
    
    //获得响应体的标识符
    NSString * identifier = request.identifier;
    
    // 唤起通知的对象
    UNNotificationTrigger * trigger = request.trigger;
    
    //获得通知内容
    UNNotificationContent * content = request.content;
    
    //比如获得我想要的alert
    NSString * alertString = content.body;
    
    //弹出Alert提示一下
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:alertString afterDelay:1];
    
    //告知完成
    completionHandler();
    
}


@end
