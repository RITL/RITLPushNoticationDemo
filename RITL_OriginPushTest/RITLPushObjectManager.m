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
#endif

/**** identifier ***/
static NSString * const locationTriggerIdentifier = @"com.yue.originPush.locationTrigger";
static NSString * const requestIdentifier = @"com.yue.originPush.myNotificationCategory";

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
    localNotification.category = requestIdentifier;
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



-(void)pushLicationNotification:(NSArray <UNNotificationAttachment *> *)attachments
{
    //初始化信息对象
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    //设置内容
    content.body = @"RITL send a location notications";
    
    //设置详细内容
    content.subtitle = @"I am SubTitle";
    
    //设置图片名称
    content.launchImageName = @"Stitch.png";
    
    //设置拓展id
    content.categoryIdentifier = requestIdentifier;
    
    //设置推送声音
    content.sound = [UNNotificationSound defaultSound];
    
    //设置通知
    content.badge = @1;
    
    //设置附带信息
    content.userInfo = @{@"RITL":@"RITL"};
    
    //媒体附带信息
    content.attachments = attachments;
    
#pragma mark - 延时发送
    UNTimeIntervalNotificationTrigger * trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:false];
    
#pragma mark - 比如每天早上七点发送
    //    NSDateComponents * dateCompents = [NSDateComponents new];
    //    dateCompents.hour = 7;
    
    //    UNCalendarNotificationTrigger * calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCompents repeats:true];
    
    
#pragma mark - 进入到某个区域的时候进行推送
    
    // 因为CLRegion类的初始化方法在iOS7提示废弃，改用它的子类CLCircularRegion
    //    CLRegion * region = [CLRegion alloc]initCircularRegionWithCenter:cooddinate2D(100,100) radius:200 identifier:locationTriggerIdentifier
    
    //    //经纬度分别都是100
    //    CLLocationCoordinate2D coordinate2D = cooddinate2D(100,100);
    //
    //    //初始化范围类
    //    CLCircularRegion * region = [[CLCircularRegion alloc]initWithCenter:coordinate2D radius:200 identifier:locationTriggerIdentifier];
    //
    //    UNLocationNotificationTrigger * locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:false];
    //
    //    NSLog(@"%@",locationTrigger);
    //
    
    //初始化通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    
    
    //获得推送控制中心
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if(error != nil)//出错
        {
            NSLog(@"error = %@",error.localizedDescription);
        }
        
        
    }];
    
}

@end
