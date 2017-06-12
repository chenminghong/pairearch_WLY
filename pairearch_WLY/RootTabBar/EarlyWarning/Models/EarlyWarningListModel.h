//
//  EarlyWarningListModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/6/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface EarlyWarningListModel : BaseModel

@property (nonatomic, copy) NSString *status;             //状态

@property (nonatomic, copy) NSString *statusName;         //状态

@property (nonatomic, copy) NSString *orderCode;          //订单编号

@property (nonatomic, copy) NSString *abnormalId;         //异常停留编号

@property (nonatomic, copy) NSString *stopTime;           //停留超时时间

@property (nonatomic, copy) NSString *startTime;          //停留时间

@property (nonatomic, copy) NSString *regions;            //停留位置

@end
