//
//  HomePageModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface HomePageModel : BaseModel

@property (nonatomic, copy) NSString *CODE;                 //负载单号

@property (nonatomic, copy) NSString *STATUS_NAME;          //当前状态

@property (nonatomic, copy) NSString *DC_ADDRESS;           //收货地址

@property (nonatomic, copy) NSString *TRANSPORT_CODE;       //订单类型

@property (nonatomic, copy) NSString *PLAN_DELIVER_TIME;    //预约装货时间

@property (nonatomic, copy) NSString *type;                 //订单当前状态类型(distribution)

@end
