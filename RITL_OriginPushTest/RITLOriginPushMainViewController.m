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
#import "RITLPushMessageManager.h"
#import "RITLPushFilesManager.h"
#import "RITL_WebViewController.h"


#ifdef __IPHONE_10_0
@import UserNotifications;
#import "UNNotificationAttachment+RITLConceniceInitialize.h"
#import "RITLOriginPushAppDelegate+RITLUserNotifications.h"
#endif

/********* objc association *********/
static NSString * const pickerViewControllerBlockIdentifier;


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
    
#ifdef __IPHONE_10_0
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserverForName:RITLOriginPushNetworkNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
       
        //获得url
        NSString * networkPath = [note.userInfo valueForKey:@"network"];
        
        //这里是避免通过策略收到通知，获取不到网址而进行跳转空网页的尴尬- -
        if (networkPath == nil || [networkPath isEqualToString:@""]) return;
        
        //进行界面跳转
        [self.navigationController pushViewController:[RITL_WebViewController webViewWithLoadUrl:networkPath title:@"百度" navigationDelegate:nil] animated:true];
        
    }];
#endif
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/// 本地推送一条信息
- (IBAction)pushAnLocalNotification:(id)sender
{
    
/// iOS10之前的本地推送,不弹出通知
#ifdef __IPHONE_10_0
    NSArray <UNNotificationAttachment *> * attachments = nil;
    
    if (self.imageView.image != nil)
    {
        attachments = [UNNotificationAttachment defaultNotificationAttachmentsWithImage:self.imageView.image];
    }
    
    
    [[RITLPushMessageManager sharedInstance] pushLicationNotification:attachments pushType:RITLPushMessageTypeNew];
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



/// 更新本地的通知
- (IBAction)updateLocationNoticiation:(id)sender
{
    [[RITLPushMessageManager sharedInstance]pushLicationNotification:[UNNotificationAttachment defaultNotificationAttachmentsWithImage:self.imageView.image] pushType:RITLPushMessageTypeUpdate];
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
