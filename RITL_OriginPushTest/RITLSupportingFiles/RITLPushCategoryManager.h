//
//  RITLOriginPushCategoryManager.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIUserNotificationCategory;

NS_ASSUME_NONNULL_BEGIN


//”我知道了“策略动作的标识符
extern NSString * const foregroundActionIdentifier;
//“我想说两句”文字策略动作标识符
extern NSString * const destructiveTextActionIdentifier;




/// 负责添加策略的管理
NS_CLASS_AVAILABLE_IOS(8_0) @interface RITLPushCategoryManager : NSObject

/// 添加iOS10之前的策略,因为它需要在注册的时候进行添加，因此返回一个策略类
+ (UIUserNotificationCategory *)addDefaultCategorysBeforeiOS10;

/// 添加最新的(iOS10)默认的策略
+ (void)addDefaultCategorys NS_AVAILABLE_IOS(10_0);

@end

NS_ASSUME_NONNULL_END
