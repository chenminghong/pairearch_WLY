//
//  OrderStatus.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/3.
//  Copyright © 2017年 Leo. All rights reserved.
//

#ifndef OrderStatus_h
#define OrderStatus_h

//订单状态
#define ORDER_STATUS_212   212  //司机未接收
#define ORDER_STATUS_220   220  //开始运输
#define ORDER_STATUS_226   226  //装货签到

#define ORDER_STATUS_228   228  //装货入厂
#define ORDER_STATUS_230   230  //装货离厂

#define ORDER_STATUS_238   238  //收货签到-->入厂-->出厂
#define ORDER_STATUS_240   240  //收货入厂
#define ORDER_STATUS_245   245  //负载单评价
#define ORDER_STATUS_241   241  //异常签收
#define ORDER_STATUS_242   242  //有单回空（或者无单回空）


//订单业务类型
#define ORDER_TYPE_KA      @"KA"            //KA类型
#define ORDER_TYPE_BACK    @"BACK"       //back回空类型
#define ORDER_TYPE_COMMON  @"COMMON"    //common常规类型



#endif /* OrderStatus_h */
