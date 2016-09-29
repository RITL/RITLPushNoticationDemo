//
//  UNNotificationAttachment+RITLConceniceInitialize.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "UNNotificationAttachment+RITLConceniceInitialize.h"
#import "RITLPushFilesManager.h"

//*********** indentifier *********//
static NSString * const attachmentIdentifier = @"com.yue.originPush.attachmentIdentifier";

/********* Key  *********/
static NSString * const imageTransformPathKey = @"imageTransformPathKey";


@implementation UNNotificationAttachment (RITLConceniceInitialize)

+(NSArray<UNNotificationAttachment *> *)defaultNotificationAttachmentsWithImage:(UIImage *)image
{
    if (image == nil) return nil;
    
    NSMutableArray <UNNotificationAttachment *> * attachments = [NSMutableArray arrayWithCapacity:1];
    
    //将image存到本地
    [RITLPushFilesManager saveImage:image key:imageTransformPathKey];
    
    NSError * error;
    
    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier URL:[RITLPushFilesManager imageUrlPathWithKey:imageTransformPathKey] options:nil error:&error];
    
    NSAssert(error == nil, error.localizedDescription);
    
    [attachments addObject:attachment];
    
    return [attachments mutableCopy];
}

@end
