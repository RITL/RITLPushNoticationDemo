//
//  NotificationViewController.m
//  NoticationContentExtension
//
//  Created by YueWen on 2016/9/26.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface RITLNotificationViewController () <UNNotificationContentExtension>

@property (weak, nonatomic) IBOutlet UILabel * customlabel;

/// 展示在拓展里自定义设置的图片
@property (weak, nonatomic) IBOutlet UIImageView * customimageView;

/// 展示通知带过来的本地图片
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;

@end

@implementation RITLNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any required interface initialization here.
}


// 收到推送消息后进行的回调
- (void)didReceiveNotification:(UNNotification *)notification
{
    //获得内容对象
    UNNotificationContent * content = notification.request.content;
    
    //获得需要展示的文本
    NSString * customTitle = content.body;
    
    //需要展示的图片
    UIImage * image = [UIImage imageNamed:content.launchImageName];
    
    //设置
    self.customlabel.text = customTitle;
    
    //这是拓展里自定义的图片
    self.customimageView.image = image;
    
    //这是通知里带的照片
    self.attachmentImageView.image = nil;//一般是网络图片
    
}



#pragma mark - <UNNotificationContentExtension>

// 展开后的推送消息得到点击响应
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
{
    //进行回调，这里是使其消失并回到主App进行处理
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}


//typedef NS_ENUM(NSUInteger, UNNotificationContentExtensionResponseOption)
//{
//    UNNotificationContentExtensionResponseOptionDoNotDismiss, //默认表示不消失
//    UNNotificationContentExtensionResponseOptionDismiss,//消失
//    UNNotificationContentExtensionResponseOptionDismissAndForwardAction,//消失并让App对它进行处理，这个时候才会走原应用的回调
//};


@end
