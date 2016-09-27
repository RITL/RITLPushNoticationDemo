//
//  RITLOriginPushAppDelegate+RITLUserNotifications.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushAppDelegate.h"

@import UserNotifications;

NS_ASSUME_NONNULL_BEGIN


/// iOS10 之后对推送进行处理的类目
@interface RITLOriginPushAppDelegate (RITLUserNotifications)<UNUserNotificationCenterDelegate>

@end

NS_ASSUME_NONNULL_END
