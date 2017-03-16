//
//  DetailCommonModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface DetailCommonModel : BaseModel

//装货
@property (nonatomic, copy) NSString *SHPM_STATUS;               //交货单状态

@property (nonatomic, copy) NSString *ORDER_CODE;                //负载单号

@property (nonatomic, copy) NSString *FRM_SHPG_LOC_NAME;         //发货地名称

@property (nonatomic, copy) NSString *FRM_SHPG_ADDR;             //发货地地址

@property (nonatomic, copy) NSString *PLAN_DELIVER_TIME;         //预约装货时间//

@property (nonatomic, copy) NSString *DRIVER_NAME;               //联系人

@property (nonatomic, copy) NSString *DRIVER_MOBILE;             //电话

@property (nonatomic, copy) NSString *TRANSPORT_CODE;            //运输类型

@property (nonatomic, copy) NSString *SHPM_STATUS_NAME;          //运单状态


//交货

@property (nonatomic, copy) NSString *BW_WGT;              //总重量

@property (nonatomic, copy) NSString *SHPM_NUM;                  //交货单

@property (nonatomic, copy) NSString *TO_SHPG_LOC_NAME;          //收货方

@property (nonatomic, copy) NSString *TO_SHPG_ADDR;              //收货方地址

@property (nonatomic, copy) NSString *APPOINTMENT_END_TIME;      //预计到货时间



@property (nonatomic, strong) NSString *isEmpty;                 //是否有回空单（0：没有；1：有）

@property (nonatomic, strong) NSString *TO_SHPG_LOC_CD;          //回空详情界面参数

@property (nonatomic, strong) NSNumber *selected;                //是否正在走流程(1:状态为230， 或者242； 0:状态既不是230， 也不是245)

@end
