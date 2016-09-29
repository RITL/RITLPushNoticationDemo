//
//  RITLPushFileManager.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 负责将图片存到本地的类
@interface RITLPushFilesManager : NSObject

/// 将图片存到本地
+ (BOOL)saveImage:(UIImage *)image key:(NSString *)key;

/// 根据key返回路径的字符串
+ (nullable NSString *)imagePathWithKey:(NSString *)key;

/// 根据key返回路径url
+ (nullable NSURL *)imageUrlPathWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
