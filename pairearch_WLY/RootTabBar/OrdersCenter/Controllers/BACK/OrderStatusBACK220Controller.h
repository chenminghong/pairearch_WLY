//
//  OrderStatusBACK220Controller.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusBACK220Controller : BaseViewController

@property (nonatomic, strong) NSDictionary *paraDict;  //参数

@property (nonatomic, assign) NSInteger orderStatus; //load单号状态

@property (nonatomic, copy) NSString *orderType; //订单类型

@property (nonatomic, strong) NSMutableArray *dataListArr;  //数据源

@end
