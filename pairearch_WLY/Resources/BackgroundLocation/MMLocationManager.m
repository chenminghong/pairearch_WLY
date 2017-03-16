//
//  MMLocationManager.m
//  DemoBackgroundLocationUpdate
//
//  Created by Ralph Li on 7/20/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "MMLocationManager.h"

@interface MMLocationManager() <CLLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;
@property (nonatomic, copy) NSString *latitude; //当前纬度
@property (nonatomic, copy) NSString *longitude; //当前经度
@property (nonatomic, strong) NSTimer *timer; //返点定时器
@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
@property (nonatomic, strong) NSString *locationAddress; //用于存储定位后的反地理编码地址
@property (nonatomic, copy) NSString *waybillNumber; //运单号
@end

@implementation MMLocationManager

+ (instancetype)sharedManager
{
    static MMLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMLocationManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.pausesLocationUpdatesAutomatically = NO; //不允许自动暂停刷新
        self.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新

        //建立监察，用于接收点击“接收运单”按钮后从详情页面传过来的消息然后控制定时器进行定时上传经纬度给后台（定时返点）
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnLatitudeAndLongitudeWithNSTimer:) name:@"returnLatitudeAndLongitude" object:nil];
        //建立监察，用于接收首页传过来的消息然后停止定时器停止返点
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopReturnLatitudeAndLongitudeWithNSTimer) name:@"stopReturnLatitudeAndLongitude" object:nil];
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations[0];
    
    NSLog(@"后台定位的经纬度, lat %f, long %f", location.coordinate.latitude, location.coordinate.longitude);
    self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
    self.geoCode = [[BMKGeoCodeSearch alloc] init];
    self.geoCode.delegate = self;

    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){location.coordinate.latitude, location.coordinate.longitude};
    self.reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    self.reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoCode reverseGeoCode:self.reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result: (BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //      在此处理正常结果
        NSLog(@"%@", result.address);
        //将地理位置存储下来，返点时要用到
        self.locationAddress = result.address;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
//用定时器返点
- (void)returnLatitudeAndLongitudeWithNSTimer:(NSNotification *)sender
{
    self.waybillNumber = [sender.userInfo objectForKey:@"waybillNumber"];
    
    if (!_timer) {
        
        //设置定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(returnLatitudeAndLongitude) userInfo:nil repeats:YES];
        [_timer fire];
    }
}
//停止定时器返点
- (void)stopReturnLatitudeAndLongitudeWithNSTimer
{
    //取消本地推送
    UIApplication *application = [UIApplication sharedApplication];
    [application cancelAllLocalNotifications];
    
    if (_timer) {
        
        //如果定时器在运行
        if ([_timer isValid]) {
            //停止定时器
            [_timer invalidate];
            //这行代码很关键
            _timer = nil;
            
        }
    }
    NSLog(@"返点停止");
}
//返点，定时器重复调用的方法
- (void)returnLatitudeAndLongitude
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *driverTel = [userInfo objectForKey:@"userName"];
    //给地址进行base64加密
    NSString *base64_locationAddress= [GTMBase64 encodeBase64String:self.locationAddress];
    //定时返点
    [self postRequestToRetureLatitudeAndLongitudeWithOrderCode:self.waybillNumber DriverTel:driverTel Longitude:self.longitude Latiude:self.latitude Speed:@"" Direction:@"" AndAddress:base64_locationAddress];
}

//上传经纬度
- (void)postRequestToRetureLatitudeAndLongitudeWithOrderCode:(NSString *)orderCode DriverTel:(NSString *)driverTel Longitude:(NSString *)longitude Latiude:(NSString *)latiude Speed:(NSString *)speed Direction:(NSString *)direction AndAddress:(NSString *)address
{
    NSLog(@"uploadLocation");
    
#warning 如果有较长时间的操作 比如HTTP上传 请使用beginBackgroundTaskWithExpirationHandler
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive )
    {
        //TODO HTTP upload
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        //防止经纬度为空而导致crash
        if (nil == longitude || nil == latiude) {
            longitude = @"0.000000";
            latiude = @"0.000000";
        }
        NSDictionary *body = @{@"type":@"APP_REBATE_SERVICE", @"operation":@"REBATE", @"requestEntity":@{@"orderCode":orderCode, @"driverTel":driverTel, @"longitude":longitude, @"latiude":latiude, @"speed":speed, @"direction":direction, @"address":address}};
        [manager POST:kPort parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSLog(@"返点成功");
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            
        }];
        [self endBackgroundUpdateTask];
    } else { //后台定位
        //假如上一次的上传操作尚未结束 则直接return
        if ( self.taskIdentifier != UIBackgroundTaskInvalid) {
            return;
        }
        
        [self beingBackgroundUpdateTask];
        
        //TODO HTTP upload
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        //防止经纬度为空而导致crash
        if (nil == longitude || nil == latiude) {
            longitude = @"0.000000";
            latiude = @"0.000000";
        }
        NSDictionary *body = @{@"type":@"APP_REBATE_SERVICE", @"operation":@"REBATE", @"requestEntity":@{@"orderCode":orderCode, @"driverTel":driverTel, @"longitude":longitude, @"latiude":latiude, @"speed":speed, @"direction":direction, @"address":address}};
        [manager POST:kPort parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSLog(@"返点成功");
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            
        }];
//        上传完成记得调用
        [self endBackgroundUpdateTask];
    }
    
}

- (void)beingBackgroundUpdateTask
{
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    if ( self.taskIdentifier != UIBackgroundTaskInvalid )
    {
        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
