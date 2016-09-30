//
//  RITLOriginPushAppDelegate+RITLUserNotifications.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate+RITLUserNotifications.h"
#import "RITLPushCategoryManager.h"

NSString * const RITLOriginPushNetworkNotification = @"RITLOriginPushNetworkNotification";

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


// 已经收到通知响应的处理方法，不管是什么通知，当通过点击推送进入或者回到App的时候触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
#pragma 这里有必要说明一下，但目前只适用于默认的远程以及本地推送，自定义UI的推送不能响应到此
#pragma 需要实现拓展中UNNotificationContentExtension协议的可选方法- didReceiveNotificationResponse:completionHandler:;
#pragma 根据以上的回调方法判定是否能走该协议方法
    
    //这里可以先对UNNotificationResponse的identifier进行判断，是正常的通知还是我们的策略
    
    if ([response.actionIdentifier isEqualToString:foregroundActionIdentifier])
    {
        //可以弹出Alert提示一下
        [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:@"我是第一个策略动作,收到了" afterDelay:0];
        
        completionHandler();return;
    }

    else if([response.actionIdentifier isEqualToString:destructiveTextActionIdentifier])
    {

        [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:[NSString stringWithFormat:@"我是第二个文本动作，我输入的文字是:%@",((UNTextInputNotificationResponse *)response).userText] afterDelay:0];
        
        completionHandler();return;
    }
    
    
    //获得响应对象
    UNNotification * notification = response.notification;
    
    //获得响应时间
//    NSDate * responseDate = notification.date;
    
    //获得响应体
    UNNotificationRequest * request = notification.request;
    
    //获得响应体的标识符
//    NSString * identifier = request.identifier;
    
    // 唤起通知的对象
//    UNNotificationTrigger * trigger = request.trigger;
    
    //获得通知内容
    UNNotificationContent * content = request.content;
    
    //比如获得我想要的alert
    NSString * alertString = content.body;
    
    //可以弹出Alert提示一下
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:alertString afterDelay:1];
    
    //比如这里可以进行界面的跳转等操作...
    
    //for example
    //获得百度的网址

    //发送一个跳转的通知
//    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:RITLOriginPushNetworkNotification object:nil userInfo:content.userInfo]];
    
    
    //告知完成
    completionHandler();
}


@end
