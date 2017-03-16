//
//  MyLocationManager.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface MyLocationManager : CLLocationManager <CLLocationManagerDelegate>

@property (nonatomic, strong) NSTimer *timer;  //定时器。

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@property (nonatomic, strong) CLLocation *loc;  //当前的位置

+ (instancetype)sharedManager;

//开启定位上传功能
+ (void)startUpdateLocationToServer;

//停止定位上传功能
+ (void)stopUpdateLocationToServer;

@end
