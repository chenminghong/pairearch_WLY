//
//  UploadLocationManager.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LocationUploadManager.h"

#define GATHER_TIMEINTERVAL  60.0    //位置信息采集周期
#define PACK_TIMEINTERVAL    300.0    //位置信息上传周期


@implementation LocationUploadManager

//初始化
+ (instancetype)shareManager {
    static LocationUploadManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [LocationUploadManager new];
        // 使用SDK的任何功能前，都需要先调用initInfo:方法设置基础信息。
        BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:BAIDU_AK mcode:[[NSBundle mainBundle] bundleIdentifier] serviceID:SERVICE_ID keepAlive:true];
        [[BTKAction sharedInstance] initInfo:sop];
        [sharedManager changeGatherAndPackIntervals:GATHER_TIMEINTERVAL packInterval:PACK_TIMEINTERVAL];
    });
    return sharedManager;
}

- (CLLocationManager *)manager {
    if (!_manager) {
        self.manager = [CLLocationManager new];
        self.manager.delegate = self;
        [self.manager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        self.manager.pausesLocationUpdatesAutomatically = NO;
        self.manager.allowsBackgroundLocationUpdates = YES;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            /** 后台定位 */
            [self.manager requestAlwaysAuthorization];
        }
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            /** iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。 */
            [self.manager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    return _manager;
}

/**
 位置更新提示
 
 @param manager 定位助手类
 @param locations 存储定位的位置信息
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    self.latestLocation = newLocation;
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", self.latestLocation.coordinate.longitude, self.latestLocation.coordinate.latitude, self.latestLocation.altitude, self.latestLocation.course, self.latestLocation.speed);
}


- (CLLocation *)latestLocation {
    CLLocationCoordinate2D coordinate = [DYLocationConverter bd09FromWgs84:_latestLocation.coordinate];
    return [[CLLocation alloc] initWithCoordinate:coordinate altitude:_latestLocation.altitude horizontalAccuracy:_latestLocation.horizontalAccuracy verticalAccuracy:_latestLocation.verticalAccuracy course:_latestLocation.course speed:_latestLocation.speed timestamp:_latestLocation.timestamp];
}

+ (BOOL)locationServicesEnabled {
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        NSLog(@"手机gps定位未开启");
        return NO;
    }
}


#pragma mark - service轨迹服务 请求

- (void)startServiceWithEntityName:(NSString *)entityName {
    self.latestEntityName = entityName;
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:entityName];
    [[BTKAction sharedInstance] startService:op delegate:self];
    [self startGather];
    [self.manager startUpdatingLocation];
}

- (void)stopService {
    [self stopGather];
    [[BTKAction sharedInstance] stopService:self];
    [self.manager stopUpdatingLocation];
}

- (void)startGather {
    [[BTKAction sharedInstance] startGather:self];
}

- (void)stopGather {
    [[BTKAction sharedInstance] stopGather:self];
}

- (void)changeGatherAndPackIntervals:(NSUInteger)gatherInterval packInterval:(NSUInteger)packInterval {
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:gatherInterval packInterval:packInterval delegate:self];
}

- (void)queryTrackLatestPoint {
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:self.latestEntityName processOption:nil outputCootdType:BTK_COORDTYPE_BD09LL serviceID:SERVICE_ID tag:100];
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
}

#pragma mark - service轨迹服务 回调

- (void)onStartService:(BTKServiceErrorCode)error {
    NSLog(@"start service response: %lu", (unsigned long)error);
}

- (void)onStopService:(BTKServiceErrorCode)error {
    NSLog(@"stop service response: %lu", (unsigned long)error);
}

- (void)onStartGather:(BTKGatherErrorCode)error {
    NSLog(@"start gather response: %lu", (unsigned long)error);
}

- (void)onStopGather:(BTKGatherErrorCode)error {
    NSLog(@"stop gather response: %lu", (unsigned long)error);
}

- (void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode)error {
    NSLog(@"change gather and pack intervals response: %lu", (unsigned long)error);
}

- (void)onGetPushMessage:(BTKPushMessage *)message {
    NSLog(@"收到推送消息，消息类型: %@", @(message.type));

    BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
    if (message.type == 0x03) {
        NSString *actionType = content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER? @"enter":@"exit";
        NSString *monitoredObject = [NSString stringWithFormat:@"%@", content.monitoredObject];
        NSString *fenceName = [NSString stringWithFormat:@"%@", content.fenceName];
        NSString *fenceID = [NSString stringWithFormat:@"%lu", (unsigned long)content.fenceID];
        NSString *lng = [NSString stringWithFormat:@"%f", content.currentPoint.coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f", content.currentPoint.coordinate.latitude];
        NSString *radius = [NSString stringWithFormat:@"%f", content.currentPoint.radius];
        NSString *pre_lng = [NSString stringWithFormat:@"%f", content.previousPoint.coordinate.longitude];
        NSString *pre_lat = [NSString stringWithFormat:@"%f", content.previousPoint.coordinate.latitude];
        NSString *pre_radius = [NSString stringWithFormat:@"%f", content.previousPoint.radius];
        
        NSDictionary *paraDict = @{@"monitored_person":monitoredObject,
                                   @"action":actionType,
                                   @"fence_name":fenceName,
                                   @"fence_id":fenceID,
                                   @"coord_type":@"",
                                   @"time":[NSString stringWithFormat:@"%llu", content.currentPoint.loctime],
                                   @"lng":lng,
                                   @"lat":lat,
                                   @"radius":radius,
                                   @"pre_lng":pre_lng,
                                   @"pre_lat":pre_lat,
                                   @"pre_time":[NSString stringWithFormat:@"%llu", content.previousPoint.loctime],
                                   @"pre_radius":pre_radius,
                                   @"driverTel":[LoginModel shareLoginModel].tel
                                   };
        [[NetworkHelper shareClient] POST:FENCE_MESSAGE_WARNING parameters:paraDict progress:nil success:nil failure:nil];
        
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已进入地理围栏 %@", fenceName]];
            NSLog(@"被监控对象 %@ 进入服务端地理围栏 %@ ", monitoredObject, fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已离开地理围栏 %@", fenceName]];
            NSLog(@"被监控对象 %@ 离开 服务端地理围栏 %@ ", monitoredObject, fenceName);
        }
    } else if (message.type == 0x04) {
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已进入地理围栏 %@", content.fenceName]];
            NSLog(@"被监控对象 %@ 进入 客户端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已离开地理围栏 %@", content.fenceName]];
            NSLog(@"被监控对象 %@ 离开 客户端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        }
    }
}

#pragma mark - API entity - 请求
- (void)addEntity:(NSString *)entityName {
    NSArray *columnArr = [entityName componentsSeparatedByString:@"_"];
    NSDictionary *columnKey = @{@"city":@"上海"};
    if (columnArr.count > 2) {
        columnKey = @{@"user_name":columnArr[0], @"tel":columnArr[1]};
    }
    BTKAddEntityRequest *request = [[BTKAddEntityRequest alloc] initWithEntityName:@"entityA" entityDesc:[NSString stringWithFormat:@"实体%@", entityName] columnKey:columnKey serviceID:SERVICE_ID tag:31];
    [[BTKEntityAction sharedInstance] addEntityWith:request delegate:self];
}

- (void)deleteEntity:(NSString *)entityName {
    BTKDeleteEntityRequest *request = [[BTKDeleteEntityRequest alloc] initWithEntityName:entityName serviceID:SERVICE_ID tag:32];
    [[BTKEntityAction sharedInstance] deleteEntityWith:request delegate:self];
}

- (void)updateEntity:(NSString *)entityName {
    NSArray *columnArr = [entityName componentsSeparatedByString:@"_"];
    NSDictionary *columnKey = @{@"city":@"上海"};
    if (columnArr.count > 2) {
        columnKey = @{@"user_name":columnArr[0], @"tel":columnArr[1]};
    }
    BTKUpdateEntityRequest *request = [[BTKUpdateEntityRequest alloc] initWithEntityName:@"entityA" entityDesc:[NSString stringWithFormat:@"实体%@", entityName] columnKey:columnKey serviceID:SERVICE_ID tag:33];
    [[BTKEntityAction sharedInstance] updateEntityWith:request delegate:self];
}

- (void)queryEntityWithEntityNames:(NSArray *)entityNames {
    BTKQueryEntityFilterOption *filter = [[BTKQueryEntityFilterOption alloc] init];
    filter.entityNames = entityNames;
    BTKQueryEntityRequest *request = [[BTKQueryEntityRequest alloc] initWithFilter:filter outputCoordType:BTK_COORDTYPE_BD09LL pageIndex:1 pageSize:100 serviceID:SERVICE_ID tag:34];
    [[BTKEntityAction sharedInstance] queryEntityWith:request delegate:self];
}

#pragma mark - API entity - 回调
- (void)onAddEntity:(NSData *)response {
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"add entity response: %@", dict);
}

- (void)onDeleteEntity:(NSData *)response {
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"delete entity response: %@", dict);
}

- (void)onUpdateEntity:(NSData *)response {
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"update entity response: %@", dict);
}

- (void)onQueryEntity:(NSData *)response {
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"query entity response: %@", dict);
}

//使用 UNNotification 本地通知
+ (void)registerNotificationWithContent:(NSString *)contentDes {
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        content.body = [NSString localizedUserNotificationStringForKey:contentDes arguments:nil];
    } else {
        content.body = [NSString stringWithFormat:@"%@", contentDes];
    }
    content.sound = [UNNotificationSound defaultSound];
    
    NSString *requestIdentifier = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:nil];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"本地通知添加成功");
        }
    }];
    
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.alertBody = [NSString stringWithFormat:@"%@", contentDes];
//    //        localNotif.hasAction = NO;
//    //注意 ：  这里是立刻弹出通知，其实这里也可以来定时发出通知，或者倒计时发出通知
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

@end
