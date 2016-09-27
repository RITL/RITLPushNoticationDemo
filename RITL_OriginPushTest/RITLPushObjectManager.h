//
//  RITLPushObjectManager.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UNNotificationAttachment;

NS_ASSUME_NONNULL_BEGIN

/// 负责推送消息
@interface RITLPushObjectManager : NSObject

/// 单例对象
+ (instancetype)sharedInstance;

/// iOS10之前的本地推送
- (void)pushLocationNotificationbeforeiOS10;

/// iOS10 之后的本地推送
- (void)pushLicationNotification:(nullable NSArray <UNNotificationAttachment *> *)attachments;

@end

NS_ASSUME_NONNULL_END
