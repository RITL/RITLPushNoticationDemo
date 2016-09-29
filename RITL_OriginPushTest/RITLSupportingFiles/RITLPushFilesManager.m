//
//  RITLPushFileManager.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPushFilesManager.h"

@implementation RITLPushFilesManager

#pragma mark - save

+(BOOL)saveImage:(UIImage *)image key:(NSString *)key
{
    //将image转成data
    NSData * imageData = UIImageJPEGRepresentation(image, 0.6);//0.6比例进行压缩
    
    NSError * error;
    
    //存到本地
    BOOL result = [imageData writeToFile:[self __appendDocumentPath:key] options:NSDataWritingAtomic error:&error];
    
    if (result == false)
    {
        NSAssert(error == nil,error.localizedDescription);
        return false;//表示保存失败
    }
    
    return true;
}

#pragma mark - read


+(NSString *)imagePathWithKey:(NSString *)key
{
    NSAssert(key != nil, @"key is not be nil");
    
    NSString * path = [self __appendDocumentPath:key];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    return nil;
}

+(NSURL *)imageUrlPathWithKey:(NSString *)key
{
    NSString * path = [self imagePathWithKey:key];
    
    if (path == nil) return nil;
    
//    测试用 $$$$
//    path = [[NSBundle mainBundle]pathForResource:@"defaultImage" ofType:@"jpg"];
    
    //进行转换
    NSURL * url = [[NSURL alloc]initFileURLWithPath:path];
    
    return url;
}



#pragma mark - private
+(NSString *)__appendDocumentPath:(NSString *)key
{
    //表示是图片一定要有后缀名字，好坑.. 2016-09-28
    return [[self __documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.png",key]];
}


/// 返回沙盒目录
+ (NSString *)__documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
}
@end
