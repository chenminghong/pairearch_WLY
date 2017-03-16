//
//  NestedSelectStateController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NestedSelectStateController : UIViewController

@property (nonatomic, strong) NSDictionary *paraDict;  //参数

@property (nonatomic, assign) NSInteger orderStatus; //load单号状态

@property (nonatomic, copy) NSString *orderType; //订单类型

@end
