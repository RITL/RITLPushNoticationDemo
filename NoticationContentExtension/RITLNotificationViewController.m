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
@property (weak, nonatomic) IBOutlet UIImageView * customimageView;

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
    NSString * customTitle = [content.userInfo valueForKey:@"RITL"];
    
    //需要展示的图片
    UIImage * image = [UIImage imageNamed:content.launchImageName];
    
    //设置
    self.customlabel.text = customTitle;
    self.customimageView.image = image;
    
    
}



#pragma mark - <UNNotificationContentExtension>

// 推送消息得到点击响应
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
{
    NSUInteger i = 0;
}

@end
