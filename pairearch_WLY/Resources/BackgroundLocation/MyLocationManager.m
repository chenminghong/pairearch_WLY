//
//  MyLocationManager.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "MyLocationManager.h"

#define UPDATE_TIMEINTERVAL 10.0  //上还位置信息到服务器的时间间隔

@implementation MyLocationManager

#pragma mark -- initMethod
+ (instancetype)sharedManager {
    static MyLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MyLocationManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if ( self )
    {
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.pausesLocationUpdatesAutomatically = NO; //不允许自动暂停刷新
        self.allowsBackgroundLocationUpdates = YES;   //允许后天刷新位置信息
        self.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
        [self allowDeferredLocationUpdatesUntilTraveled:0.01 timeout:5.0];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocation *loc = [locations objectAtIndex:0];
 //   NSLog(@"经纬度:%f/%f ", loc.coordinate.latitude, loc.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

//开启定位上传功能
+ (void)startUpdateLocationToServer {
    MyLocationManager *manager = [MyLocationManager sharedManager];
    if (!manager.timer) {
        //设置定时器
        manager.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIMEINTERVAL target:manager selector:@selector(updateLocationToServer) userInfo:nil repeats:YES];
        [manager startUpdatingLocation];
    }
}

//停止定位上传功能
+ (void)stopUpdateLocationToServer {
    //取消本地推送
//    UIApplication *application = [UIApplication sharedApplication];
//    [application cancelAllLocalNotifications];
    
    MyLocationManager *manager = [MyLocationManager sharedManager];
    if (manager.timer) {
        //如果定时器在运行
        if ([manager.timer isValid]) {
            //停止定时器
            [manager.timer invalidate];
            //这行代码很关键
            manager.timer = nil;
        }
    }
    NSLog(@"返点停止");
}

//上传位置信息到服务器
- (void)updateLocationToServer {
    NSLog(@"经纬度:%f/%f aaaaa", self.location.coordinate.latitude, self.location.coordinate.longitude);
    
    if (self.location != nil) {
        [self begainBackgroundUpdateTask];
        [[NetworkHelper shareClient] POST:@"" parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            
            [self endBackgroundUpdateTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self endBackgroundUpdateTask];
        }];
    }
}


//开始后台任务
- (void)begainBackgroundUpdateTask {
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}


//结束后台任务
 - (void)endBackgroundUpdateTask{
    if ( self.taskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
