//
//  RITLOpenFunction.h
//  RITL_OriginPushTest
//
//  Created by YueWen on 2016/9/27.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#ifndef RITLOpenFunction_h
#define RITLOpenFunction_h

#ifdef __IPHONE_10_0
@import CoreLocation;
#else
#import <CoreLocation/CoreLocation.h>
#endif

static inline CLLocationCoordinate2D cooddinate2D(CLLocationDegrees latitude,CLLocationDegrees longitude)
{
    CLLocationCoordinate2D locationCoordinate2D;
    
    //set value
    locationCoordinate2D.latitude = latitude;
    locationCoordinate2D.longitude = longitude;
    
    return locationCoordinate2D;
}


#endif /* RITLOpenFunction_h */
