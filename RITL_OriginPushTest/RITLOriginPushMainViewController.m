//
//  ViewController.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLOriginPushMainViewController.h"
#import "RITLOpenFunction.h"
#import <objc/runtime.h>
#import "RITLPushObjectManager.h"
#import "RITLPushFileManager.h"

#ifdef __IPHONE_10_0
@import UserNotifications;
#endif


//*********** indentifier *********//
static NSString * const attachmentIdentifier = @"com.yue.originPush.attachmentIdentifier";


/********* objc association *********/
static NSString * const pickerViewControllerBlockIdentifier;

/********* Key  *********/
static NSString * const imageTransformPathKey = @"imageTransformPathKey";

@interface RITLOriginPushMainViewController ()


/// 图片选择控制器
@property (nonatomic, strong) UIImagePickerController * imagePickerController;

/// 图片选择控制器的代理
@property (nonatomic, strong) RITLImagePickerControllerDelegate * pickerControllerDelegate;


@end

@implementation RITLOriginPushMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/// 本地推送一条信息
- (IBAction)pushAnLocalNotification:(id)sender
{
    
/// iOS10之前的本地推送,不弹出通知
#ifdef __IPHONE_10_0
    NSMutableArray <UNNotificationAttachment *> * attachments = [NSMutableArray arrayWithCapacity:1];
    
    if (self.imageView.image == nil)
    {
        attachments = nil;
    }
    
    else
    {
        //将image存到本地
        [RITLPushFileManager saveImage:self.imageView.image key:imageTransformPathKey];
        
        __autoreleasing NSError * error;

//        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier URL:[RITLPushFileManager imageUrlPathWithKey:imageTransformPathKey] options:nil error:&error];
        
        NSAssert(error == nil, error.localizedDescription);
    
//        [attachments addObject:attachment];
        
#warning 待查找原因，临时不附带媒体 2016-09-27
        attachments = nil;
    }
    
    
    [[RITLPushObjectManager sharedInstance] pushLicationNotification:[attachments mutableCopy]];
#else
     [RITLPushObjectManager sharedInstance] pushLocationNotificationbeforeiOS10];

#endif
}

/// 从本地选择一张照片
- (IBAction)wantChooseAnImage:(id)sender
{
    NSLog(@"choose an image");
    
    self.pickerControllerDelegate = [RITLImagePickerControllerDelegate new];
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //设置代理
    self.imagePickerController.delegate = self.pickerControllerDelegate;
    
    
    __weak typeof(self) weakSelf = self;
    
    //设置回调
    void(^block)(NSDictionary <NSString *, id> *)=^(NSDictionary <NSString *, id> * info){
        
        //获得图片对象
        weakSelf.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
    };
    
    //设置属性
    objc_setAssociatedObject(self.pickerControllerDelegate, &pickerViewControllerBlockIdentifier, block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //弹出控制器
    [self presentViewController:self.imagePickerController animated:true completion:^{}];
}



@end








@implementation RITLImagePickerControllerDelegate

#pragma mark - <RITLImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //回调数据
    id block = objc_getAssociatedObject(self, &pickerViewControllerBlockIdentifier);
    
    if (block != nil)
    {
        //类型进行强转执行
        ((void(^)(NSDictionary<NSString *,id> * info))block)(info);
    }
    
    //退出
    [picker dismissViewControllerAnimated:true completion:^{}];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:^{}];
}


-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}

@end
