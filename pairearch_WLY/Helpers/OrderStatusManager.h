//
//  OrderStatusManager.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/3.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatusManager : NSObject

//获取表单状态对应的title
+ (NSString *)getStatusTitleWithOrderStatus:(NSInteger)orderStatus orderType:(NSString *)orderType;

//获取BACK回空签到时描述
+ (NSString *)getOrderDescriptionWithStatus:(NSInteger)status orderType:(NSString *)orderType;

//根据订单类型和当前订单状态,获取下一步订单状态
+ (NSInteger)getNextProcessWithCurrentStatus:(NSInteger)currentStatus orderType:(NSString *)orderType;

//获取订单类型名称
+ (NSString *)getOrderTypeDesStringWithOrderTyoe:(NSString *)orderType;

@end
