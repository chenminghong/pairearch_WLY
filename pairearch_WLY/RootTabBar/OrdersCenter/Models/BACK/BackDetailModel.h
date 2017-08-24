//
//  BackDetailModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface BackDetailModel : BaseModel

//装货
@property (nonatomic, copy) NSString *SHPM_STATUS;               //交货单状态

@property (nonatomic, copy) NSString *ORDER_CODE;                //负载单号

@property (nonatomic, copy) NSString *FRM_SHPG_LOC_NAME;         //发货地名称

@property (nonatomic, copy) NSString *FRM_SHPG_ADDR;             //发货地址

@property (nonatomic, copy) NSString *PLAN_DELIVER_TIME;         //预约装货时间

@property (nonatomic, copy) NSString *DRIVER_NAME;               //联系人

@property (nonatomic, copy) NSString *DRIVER_MOBILE;             //电话

@property (nonatomic, copy) NSString *TRANSPORT_CODE;            //运输类型

@property (nonatomic, copy) NSString *SHPM_STATUS_NAME;          //运单状态

@property (nonatomic, copy) NSString *TO_DLVY_DTT;               //预计送达日期

@property (nonatomic, copy) NSString *FRM_DPND_CMTD_STRT_DTT;    //开始时间点

@property (nonatomic, copy) NSString *FRM_DPND_CMTD_END_DTT;     //结束时间点

@property (nonatomic, copy) NSString *STATUS;                    //负载单状态码


//交货
@property (nonatomic, copy) NSString *SHPM_NUM;                  //交货单

@property (nonatomic, copy) NSString *TO_SHPG_LOC_NAME;          //收货方名称

@property (nonatomic, copy) NSString *TO_SHPG_ADDR;              //收货方地址

@property (nonatomic, copy) NSString *APPOINTMENT_END_TIME;      //预计到货时间

@property (nonatomic, strong) NSNumber *selected;                //是否选中异常签收按钮(0:异常, 1:正常)

@end
