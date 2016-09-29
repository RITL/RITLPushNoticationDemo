//
//  RITLOriginPushCategoryManager.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPushCategoryManager.h"
#import "RITLPushMessageManager.h"
#import <UIKit/UIKit.h>

@import UserNotifications;

#pragma identifier

NSString * const foregroundActionIdentifier = @"foregroundActionIdentifier ";
NSString * const destructiveTextActionIdentifier = @"destructiveTextActionIdentifier";


@implementation RITLPushCategoryManager


#pragma 枚举

#pragma iOS10 UNNotificationActionOptions，位于<UNNotificationAction.h>

// typedef NS_OPTIONS(NSUInteger, UNNotificationActionOptions)
// {
//     UNNotificationActionOptionAuthenticationRequired = (1 << 0),//在执行的时候必须要解锁
//     UNNotificationActionOptionDestructive = (1 << 1),           //按钮会被红色警示
//     UNNotificationActionOptionForeground = (1 << 2),            //会造成应用响应到前台
// };


#pragma iOS10 UNNotificationCategoryOptions,位于<NNotificationCategory.h>

//typedef NS_OPTIONS(NSUInteger, UNNotificationCategoryOptions)
//{
//    UNNotificationCategoryOptionNone = (0),                       //不进行任何的响应
//    UNNotificationCategoryOptionCustomDismissAction = (1 << 0),   //当响应消失的时候发送消息给UNUserNotificationCenter delegate
//    UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),        //此通知的拓展需要在车载系统中被准许(不知道啥意思，难不成和苹果汽车有关系？)
//};


#pragma mark - public Function

+(UIUserNotificationCategory *)addDefaultCategorysBeforeiOS10
{
    //设置普通响应 -- 表示没有便利初始化方法很坑
    UIMutableUserNotificationAction * foregroundAction = [UIMutableUserNotificationAction new];
    //设置属性
    foregroundAction.identifier = foregroundActionIdentifier;
    foregroundAction.title = @"收到了";
    foregroundAction.activationMode = UIUserNotificationActivationModeForeground;
    
    
    //设置文本响应
    UIMutableUserNotificationAction * destructiveTextAction = [UIMutableUserNotificationAction new];
    //设置属性
    destructiveTextAction.identifier = destructiveTextActionIdentifier;
    destructiveTextAction.title = @"我想说两句";
    destructiveTextAction.activationMode = UIUserNotificationActivationModeForeground;
    destructiveTextAction.behavior = UIUserNotificationActionBehaviorTextInput;
    destructiveTextAction.authenticationRequired = false;
    destructiveTextAction.destructive = true;
    
    //初始化Category
    UIMutableUserNotificationCategory * category = [UIMutableUserNotificationCategory new];
    //设置属性
    category.identifier = RITLRequestIdentifier;
    [category setActions:@[foregroundAction,destructiveTextAction] forContext:UIUserNotificationActionContextDefault];
    
    //返回
    return [category copy];
}




+(void)addDefaultCategorys
{
    // 设置响应
    UNNotificationAction * foregroundAction = [UNNotificationAction actionWithIdentifier:foregroundActionIdentifier title:@"收到了" options:UNNotificationActionOptionForeground];
    
    // 设置文本响应
    UNTextInputNotificationAction * destructiveTextAction = [UNTextInputNotificationAction actionWithIdentifier:destructiveTextActionIdentifier title:@"我想说两句" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"想说什么?"];
    
    // 初始化策略对象,这里的categoryWithIdentifier一定要与需要使用Category的UNNotificationRequest的identifier相同才可触发
    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:RITLRequestIdentifier actions:@[foregroundAction,destructiveTextAction] intentIdentifiers:@[foregroundActionIdentifier,destructiveTextActionIdentifier] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //设置策略
    [[UNUserNotificationCenter currentNotificationCenter]setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
}

@end
