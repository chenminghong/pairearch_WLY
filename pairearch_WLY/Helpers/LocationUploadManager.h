//
//  UploadLocationManager.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaiduTraceSDK/BaiduTraceSDK.h"

@interface LocationUploadManager : NSObject<BTKTraceDelegate, BTKFenceDelegate, BTKTrackDelegate, BTKEntityDelegate>

@property (nonatomic, copy) NSString *latestEntityName;


/**
 初始化定位上传助手对象

 @return 返回创建的助手对象
 */
+ (instancetype)shareManager;

#pragma mark - service轨迹服务 请求


/**
 开启轨迹服务

 @param entityName 实体的名称
 */
- (void)startServiceWithEntityName:(NSString *)entityName;


/**
 停止轨迹服务
 */
- (void)stopService;


/**
 开始打包
 */
- (void)startGather;


/**
 结束打包
 */
- (void)stopGather;


/**
 改变定位上传打包和上传周期

 @param gatherInterval 采集周期
 @param packInterval 打包上传周期
 */
- (void)changeGatherAndPackIntervals:(NSUInteger)gatherInterval packInterval:(NSUInteger)packInterval;

#pragma mark - API entity - 请求


/**
 添加实体

 @param entityName 实体的名称
 */
- (void)addEntity:(NSString *)entityName;


/**
 删除实体

 @param entityName 删除的实体的名称
 */
- (void)deleteEntity:(NSString *)entityName;


/**
 更新实体

 @param entityName 更新的实体的名称
 */
- (void)updateEntity:(NSString *)entityName;


/**
 查询实体

 @param entityNames 要查询的实体的集合
 */
- (void)queryEntityWithEntityNames:(NSArray *)entityNames;


/**
 注册本地通知

 @param contentDes 需要通知的内容信息
 */
+ (void)registerNotificationWithContent:(NSString *)contentDes;


@end
