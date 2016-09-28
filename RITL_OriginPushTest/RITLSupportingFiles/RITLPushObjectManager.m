//
//  RITLPushObjectManager.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPushObjectManager.h"
#import <UIKit/UIKit.h>

#ifdef __IPHONE_10_0
@import UserNotifications;
#import "UNNotificationTrigger+RITLConveniceInitialize.h"
#endif

/**** extern ****/
NSString * const RITLRequestIdentifier = @"com.yue.originPush.myNotificationCategory";


@implementation RITLPushObjectManager

+(instancetype)sharedInstance
{
    static RITLPushObjectManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    
    return manager;
}


-(void)pushLocationNotificationbeforeiOS10
{
    UILocalNotification * localNotification = [[UILocalNotification alloc]init];
    
    //设置消息体
    localNotification.alertBody = @"RITL send a location notications (iOS9)";
    
#ifdef __IPHONE_8_2
    //设置详细内容,iOS8.2才存在
    localNotification.alertTitle = @"I am SubTitle";
#endif
    
    //设置弹出时的图
    localNotification.alertLaunchImage = @"Stitch.png";
    
#ifdef __IPHONE_8_0
    //拓展id
    localNotification.category = RITLRequestIdentifier;
#endif
    
    //触发声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //触发标志
    localNotification.applicationIconBadgeNumber = 1;
    
    //1秒之后触发
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    //注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}



-(void)pushLicationNotification:(NSArray<UNNotificationAttachment *> *)attachments
{
    [self pushLicationNotification:attachments pushType:RITLPushObjectTypeNew];
}



-(void)pushLicationNotification:(NSArray <UNNotificationAttachment *> *)attachments pushType:(RITLPushObjectType)type
{
    
    NSString * subTitle = (type == RITLPushObjectTypeNew ? @"I am a new SubTitle" : @"I am a update SubTitle");
    
    //初始化信息对象
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    //设置内容
    content.body = @"RITL send a location notications";
    
    //设置详细内容
    content.subtitle = subTitle;
    
    //设置图片名称
    content.launchImageName = @"Stitch.png";
    
    //设置拓展id
    content.categoryIdentifier = RITLRequestIdentifier;
    
    //设置推送声音
    content.sound = [UNNotificationSound defaultSound];
    
    //设置通知
    content.badge = @1;
    
    //设置附带信息
    content.userInfo = @{@"RITL":@"RITL",@"network":@"https://www.baidu.com"};
    
    //媒体附带信息
    content.attachments = attachments;
    
#pragma mark - 延时发送
    UNTimeIntervalNotificationTrigger * trigger = [UNNotificationTrigger defaultTimeIntervalNotificationTrigger];
    
#pragma mark - 比如每天早上七点发送
    UNCalendarNotificationTrigger * calendarTrigger = [UNNotificationTrigger defaultCalendarNotificationTrigger];
    
    
#pragma mark - 到某个区域的时候进行推送
    UNLocationNotificationTrigger * locationTrigger = [UNNotificationTrigger defaultLocationNotificationTrigger];
                                                           
                                                           
    //初始化通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:RITLRequestIdentifier content:content trigger:trigger];
    
    //如果是更新，先移除
    if (type == RITLPushObjectTypeUpdate)
        [[UNUserNotificationCenter currentNotificationCenter]removeDeliveredNotificationsWithIdentifiers:@[RITLRequestIdentifier]];
    
    
    //获得推送控制中心
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if(error != nil)//出错
        {
            NSLog(@"error = %@",error.localizedDescription);
        }
    }];
}




@end
