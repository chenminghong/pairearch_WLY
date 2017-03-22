//
//  LocationUploadManager.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LocationUploadManager.h"


static BTRACE *traceInstance = NULL;

#define TEMP_ENTITY_NAME  @"entity_name"

#define GATHER_TIMEINTERVAL  180.0    //位置信息采集周期
#define PACK_TIMEINTERVAL    180.0    //位置信息上传周期


@implementation LocationUploadManager

//初始化
+ (instancetype)shareManager {
    static LocationUploadManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [LocationUploadManager new];
    });
    return sharedManager;
}

//重新设置追踪的实体
- (void)setEntityWithEntityName:(NSString *)entityName {
    if (entityName.length) {
        //重新开始定位上传服务
        if (traceInstance != NULL) {
            [[LocationUploadManager shareManager] stopTrace];
        }
        traceInstance = [[BTRACE alloc] initWithAk:BAIDU_AK mcode:[[NSBundle mainBundle] bundleIdentifier] serviceId:SERVER_ID entityName:entityName operationMode:2];
        [traceInstance setInterval:GATHER_TIMEINTERVAL packInterval:PACK_TIMEINTERVAL];
        [[LocationUploadManager shareManager] startTrace];
    }
}

//开始追踪轨迹
- (void)startTrace {
    [[BTRACEAction shared] startTrace:self trace:traceInstance];
}

//结束追踪轨迹
- (void)stopTrace {
    [[BTRACEAction shared] stopTrace:self trace:traceInstance];
    NSLog(@"停止上传位置信息");
}

#pragma mark -- ApplicationServiceDelegate

//开始追踪调用的方法
- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"errNo: %ld, errMsg: %@", (long)errNo, errMsg);
}

//结束追踪调用的方法
- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"errNo: %ld, errMsg: %@", (long)errNo, errMsg);
}

//地理围栏通知
- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString *)msgContent {
    [[self class] registerNotification:5 content:msgContent];
}

//使用 UNNotification 本地通知
+ (void)registerNotification:(NSInteger)alerTime content:(NSString *)contentDes {
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

//每次打包数据需要返回包信息的方法
- (NSDictionary<NSString *,NSString *> *)trackAttr {
//    NSLog(@"DATE:%@", [NSDate date]);
    
    return @{@"UUID":[[UIDevice currentDevice] identifierForVendor].UUIDString};
}



@end
