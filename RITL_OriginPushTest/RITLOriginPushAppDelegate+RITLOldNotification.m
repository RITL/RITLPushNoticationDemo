//
//  RITLOriginPushAppDelegate+OldNotification.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate+RITLOldNotification.h"

@implementation RITLOriginPushAppDelegate (RITLOldNotification)

//通过点击远程推送进入App执行的方法,不管是应用被杀死还是位于后台
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到的信息
    NSLog(@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
    
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:@"通过点击推送进入App" afterDelay:0];
}


// 在前台收到远程推送执行的方法,如果实现了iOS10的协议方法，该方法不执行,虽然没有标明废弃
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //这个时候不会弹出推送，通常，在此处进行一次本地推送，进行通知
    
    //coding..
    
    
    //回调
    completionHandler(UIBackgroundFetchResultNewData);
}



// 收到本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //coding to handle local notification
    NSLog(@"本地推送啦!");
    
    //获得文本与详细内容
    NSString * content = [NSString stringWithFormat:@"本地通知:title = %@, subTitle = %@",notification.alertBody,notification.alertTitle];
    
    
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:content afterDelay:1];
}




@end
