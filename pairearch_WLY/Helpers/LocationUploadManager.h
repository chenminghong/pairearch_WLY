//
//  LocationUploadManager.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>


@interface LocationUploadManager : NSObject <ApplicationServiceDelegate>

//初始化
+ (instancetype)shareManager;

//重新设置追踪的实体
- (void)setEntityWithEntityName:(NSString *)entityName;

//开始追踪轨迹
- (void)startTrace;

//结束追踪轨迹
- (void)stopTrace;

//使用 UNNotification 本地通知
+ (void)registerNotification:(NSInteger)alerTime content:(NSString *)contentDes;


@end
