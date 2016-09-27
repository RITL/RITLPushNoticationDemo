//
//  RITLOriginPushAppDelegate+RITLNotifaicationManager.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate.h"

#ifdef __IPHONE_10_0
@import UserNotifications;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RITLOriginPushAppDelegate (RITLNotificationManager)

@end



/// 负责注册推送的管理类
@interface RITLNotificationManager : NSObject

/// 单例对象
+ (instancetype)sharedInstance;


/// 注册远程推送
#ifdef __IPHONE_10_0
- (void)registerRemoteNotificationsApplication:(id<UNUserNotificationCenterDelegate>)application;
#else
- (void)registerRemoteNotificationsApplication:(id)application;
#endif

@end



NS_ASSUME_NONNULL_END
