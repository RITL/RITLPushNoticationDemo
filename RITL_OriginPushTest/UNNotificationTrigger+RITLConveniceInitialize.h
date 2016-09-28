//
//  UNNotificationTrigger+RITLConveniceInitialize.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN


/// 仅仅为了Demo提供便利的初始化方法
@interface UNNotificationTrigger (RITLConveniceInitialize)

/// 默认的延时推送触发时机
+ (UNTimeIntervalNotificationTrigger *)defaultTimeIntervalNotificationTrigger;

/// 默认的日历推送触发时机
+ (UNCalendarNotificationTrigger *)defaultCalendarNotificationTrigger;

/// 默认的地域推送触发时机
+ (UNLocationNotificationTrigger *)defaultLocationNotificationTrigger;

@end


NS_ASSUME_NONNULL_END
