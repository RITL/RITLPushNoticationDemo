//
//  NotificationService.m
//  NoticationServiceExtension
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

//远程推送！！！！！！！！！！！！

//大约会给30秒的时间限制
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    //获取request以及block对象
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    
    //对内容可以进行修改
    self.bestAttemptContent.body = @"我是在Service里面修改后的title";
    
    //如果如果含有图片，视频音频的url，可以利用这里进行下载coding...
    
    //然后初始化UNNotificationAttachment对象，赋值数组即可
    
    //回调处理完毕的content内容
    self.contentHandler(self.bestAttemptContent);
}


//提供最后一个机会，当该拓展将被系统杀死的时候执行的方法
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    //就比如上面英文介绍所说的：可以用这个机会来表达一下你最想在content中表达的，不然的话最初推送的payload将被用到
    self.contentHandler(self.bestAttemptContent);
}

@end
