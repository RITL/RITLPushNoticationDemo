//
//  UNNotificationAttachment+RITLConceniceInitialize.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 仅仅是为了Demo提供便利的初始化方法
@interface UNNotificationAttachment (RITLConceniceInitialize)

/// 根据图片获得默认的UNNotificationAttachment对象
+ (nullable NSArray <UNNotificationAttachment *> *)defaultNotificationAttachmentsWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
