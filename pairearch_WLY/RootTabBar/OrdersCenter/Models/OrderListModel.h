//
//  OrderListModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

/*
 {
 "APPOINTMENT_END_TIME" = "2000-01-01 17:00:00";
 "APPOINTMENT_START_TIME" = "2000-01-01 09:00:00";
 "BS_LDN_LEN" = 0;
 "BW_WGT" = "0.1";
 "CDTY_CD" = "EB_PLT";
 "CMPDDROPARVL_DTT" = "<null>";
 "CRTD_DTT" = "2016-02-04 00:00:00";
 "DRIVER_ACCEPT_TIME" = "2017-02-24 21:43:39";
 "DRIVER_MOBILE" = 18100000001;
 "DRIVER_NAME" = "\U5b8f\U8c611";
 "FRM_DLVY_DTT" = "2016-02-04 00:00:00";
 "FRM_PKUP_DTT" = "2016-02-04 00:00:00";
 "FRM_SHPG_ADDR" = "\U56db\U5ddd\U7701\U6210\U90fd\U91d1\U50cf\U5bfa\U56db\U7ec4102\U53f7";
 "FRM_SHPG_ADDR_ID" = 8702;
 "FRM_SHPG_LOC_CD" = 000000000206809;
 "FRM_SHPG_LOC_NAME" = "\U6210\U90fd\U5b59\U6c0f\U9152\U4e1a\U6709\U9650\U516c\U53f8";
 ID = 22;
 "ID_CARD" = "<null>";
 "LD_LEG_ID" = 40054669;
 "LOAD_INTO_FACTORY_TIME" = "2017-02-24 21:46:05";
 "LOAD_OUT_FACTORY_TIME" = "<null>";
 "LOAD_SIGNIN_TIME" = "2017-02-24 21:44:04";
 "ORDER_CODE" = 40054669;
 "RFRC_NUM1" = 10007874;
 "SHPM_NUM" = W000812910;
 "SHPM_STATUS" = 242;
 "SHPM_STATUS_NAME" = "\U6536\U8d27\U79bb\U5382";
 "TOT_PCE" = 1;
 "TOT_SKID" = 0;
 "TO_DLVY_DTT" = "2016-02-19 00:00:00";
 "TO_PKUP_DTT" = "2016-02-19 00:00:00";
 "TO_SHPG_ADDR" = "\U56db\U5ddd\U7701\U6210\U90fd\U91d1\U50cf\U5bfa\U56db\U7ec4102\U53f7";
 "TO_SHPG_ADDR_ID" = 13232;
 "TO_SHPG_LOC_CD" = 000000000206809;
 "TO_SHPG_LOC_NAME" = "\U6210\U90fd\U5b59\U6c0f\U9152\U4e1a\U6709\U9650\U516c\U53f8";
 "TRANSPORT_CODE" = BACK;
 "TRUCK_NUM" = "\U6caa120202";
 "TRUCK_TYPE" = "17.5\U4fa7\U5e18\U8f66";
 "UNLOAD_INTO_FACTORY_TIME" = "2017-02-24 22:24:40";
 "UNLOAD_OUT_FACTORY_TIME" = "2017-02-24 22:24:45";
 "UNLOAD_SIGNIN_TIME" = "2017-02-24 21:59:18";
 "UPDT_DTT" = "2016-02-15 00:00:00";
 }
 */

@interface OrderListModel : BaseModel

@property (nonatomic, copy) NSString *CODE;                //负载单号

@property (nonatomic, copy) NSString *SOURCE_NAME;         //发货地名称

@property (nonatomic, copy) NSString *SOURCE_ADDR;         //发货地地址

@property (nonatomic, copy) NSString *PLAN_DELIVER_TIME;   //预约发货时间

@property (nonatomic, copy) NSString *TOTAL_WEIGHT;        //货物吨重

@property (nonatomic, copy) NSString *TRANSPORT_CODE;      //订单类型

@property (nonatomic, copy) NSString *STATUS;              //订单状态

@property (nonatomic, copy) NSString *STATUS_NAME;         //订单状态描述

@property (nonatomic, copy) NSString *DC_NAME;             //收货地名称

@property (nonatomic, copy) NSString *DC_ADDRESS;          //收货地址

@property (nonatomic, copy) NSString *PLAN_ACHIEVE_TIME;   //预约到货时间

@property (nonatomic, copy) NSString *DRIVER_ORDER_TIME;   //运单开始时间

@property (nonatomic, assign) BOOL isSelected;             //是否选中



@end
