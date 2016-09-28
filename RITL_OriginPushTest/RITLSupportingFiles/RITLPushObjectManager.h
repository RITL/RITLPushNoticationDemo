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

typedef NS_ENUM(NSUInteger, RITLPushObjectType)
{
    RITLPushObjectTypeNew = 0,     /**<默认为推送新的推送通知*/
    RITLPushObjectTypeUpdate = 1,  /**<更新当前的推送通知*/
};


/// 本地推送的标识符
extern NSString * const RITLLocationRequestIdentifier;

/// 负责推送消息
@interface RITLPushObjectManager : NSObject

/// 单例对象
+ (instancetype)sharedInstance;

/// iOS10之前的本地推送
- (void)pushLocationNotificationbeforeiOS10;

/// iOS10 之后的本地推送,default type is RITLPushObjectTypeNew
- (void)pushLicationNotification:(nullable NSArray <UNNotificationAttachment *> *)attachments NS_AVAILABLE_IOS(10_0) __deprecated_msg("Use -pushLicationNotification:pushType instead.");


/// iOS10 之后的本地推送，并根据类型选择是新的推送还是更新
- (void)pushLicationNotification:(nullable NSArray <UNNotificationAttachment *> *)attachments pushType:(RITLPushObjectType)type NS_AVAILABLE_IOS(10_0);

@end

NS_ASSUME_NONNULL_END
