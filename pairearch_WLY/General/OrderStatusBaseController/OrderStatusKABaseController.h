//
//  OrderStatusKABaseController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^NextStepBlock)(NSDictionary *paraDict);

@interface OrderStatusKABaseController : BaseViewController

@property (nonatomic, copy) NextStepBlock nextBlock;

@end
