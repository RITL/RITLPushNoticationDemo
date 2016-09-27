//
//  ViewController.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UNNotificationAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface RITLOriginPushMainViewController : UIViewController

/// 显示图片的控制器
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end




/// 图片选择控制器
@interface RITLImagePickerControllerDelegate : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

NS_ASSUME_NONNULL_END

