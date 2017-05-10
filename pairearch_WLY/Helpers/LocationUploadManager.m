//
//  UploadLocationManager.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LocationUploadManager.h"

#define GATHER_TIMEINTERVAL  30.0    //位置信息采集周期
#define PACK_TIMEINTERVAL    60.0    //位置信息上传周期

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

#pragma mark - service轨迹服务 请求

- (void)startServiceWithEntityName:(NSString *)entityName {
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:entityName];
    [[BTKAction sharedInstance] startService:op delegate:self];
    [self startGather];
}

- (void)stopService {
    [[BTKAction sharedInstance] stopService:self];
    [self stopGather];
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
    if (message.type == 0x03) {
        BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已进入地理围栏 %@", content.fenceName]];
            NSLog(@"被监控对象 %@ 进入服务端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
            [[self class] registerNotificationWithContent:[NSString stringWithFormat:@"您已离开地理围栏 %@", content.fenceName]];
            NSLog(@"被监控对象 %@ 离开 服务端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        }
    } else if (message.type == 0x04) {
        BTKPushMessageFenceAlarmContent *content = (BTKPushMessageFenceAlarmContent *)message.content;
        if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_ENTER) {
            NSLog(@"被监控对象 %@ 进入 客户端地理围栏 %@ ", content.monitoredObject, content.fenceName);
        } else if (content.actionType == BTK_FENCE_MONITORED_OBJECT_ACTION_TYPE_EXIT) {
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
    //    content.title = [NSString localizedUserNotificationStringForKey:@"您好!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:contentDes arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    NSString *requestIdentifier = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:nil];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"本地通知添加成功");
        }
    }];
}

@end
