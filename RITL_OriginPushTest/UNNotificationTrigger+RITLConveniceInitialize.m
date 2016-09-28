//
//  UNNotificationTrigger+RITLConveniceInitialize.m
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/28.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "UNNotificationTrigger+RITLConveniceInitialize.h"
#import "RITLOpenFunction.h"


/**** identifier ***/
static NSString * const locationTriggerIdentifier = @"com.yue.originPush.locationTrigger";

@implementation UNNotificationTrigger (RITLConveniceInitialize)

+(UNTimeIntervalNotificationTrigger *)defaultTimeIntervalNotificationTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:false];
}



+(UNCalendarNotificationTrigger *)defaultCalendarNotificationTrigger
{
    
    NSDateComponents * dateCompents = [NSDateComponents new];
    dateCompents.hour = 7;//表示每天的7点进行推送
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCompents repeats:true];
}


+(UNLocationNotificationTrigger *)defaultLocationNotificationTrigger
{
    // 因为CLRegion类的初始化方法在iOS7提示废弃，改用它的子类CLCircularRegion
    //    CLRegion * region = [CLRegion alloc]initCircularRegionWithCenter:cooddinate2D(100,100) radius:200 identifier:locationTriggerIdentifier
    
    //经纬度分别都是100
    CLLocationCoordinate2D coordinate2D = cooddinate2D(100,100);

    //初始化范围类
    CLCircularRegion * region = [[CLCircularRegion alloc]initWithCenter:coordinate2D radius:200 identifier:locationTriggerIdentifier];

    return [UNLocationNotificationTrigger triggerWithRegion:region repeats:false];

}


@end
