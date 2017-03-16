//
//  OrderStatusManager.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/3.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusManager.h"

@implementation OrderStatusManager


//根据订单状态获取相应的title
+ (NSString *)getStatusTitleWithOrderStatus:(NSInteger)orderStatus orderType:(NSString *)orderType {
    NSString *title = @"";
    if ([orderType isEqualToString:ORDER_TYPE_KA]) {
        switch (orderStatus) {
            case ORDER_STATUS_212:
                title = @"待开始";
                break;
                
            case ORDER_STATUS_220:
                title = @"装货在途";
                break;
                
            case ORDER_STATUS_226:
                title = @"厂外排队";
                break;
                
            case ORDER_STATUS_228:
                title = @"装货中";
                break;
                
            case ORDER_STATUS_230:
                title = @"货在途中";
                break;
                
            case ORDER_STATUS_238:
                title = @"收货-厂外排队";
                break;
                
            case ORDER_STATUS_240:
                title = @"收货-厂外排队";
                break;
                
            default:
                break;
        }
    } else if ([orderType isEqualToString:ORDER_TYPE_BACK]) {
        switch (orderStatus) {
            case ORDER_STATUS_212:
                title = @"待开始";
                break;
                
            case ORDER_STATUS_220:
                title = @"装货在途";
                break;
                
            case ORDER_STATUS_226:
                title = @"待入厂";
                break;
                
            case ORDER_STATUS_228:
                title = @"装货中";
                break;
                
            case ORDER_STATUS_230:
                title = @"送货在途";
                break;
                
            case ORDER_STATUS_238:
                title = @"待卸货";
                break;
                
            case ORDER_STATUS_240:
                title = @"卸货中";
                break;
                
            default:
                break;
        }
    } else if ([orderType isEqualToString:ORDER_TYPE_COMMON]) {
        switch (orderStatus) {
            case ORDER_STATUS_212:
                title = @"待开始";
                break;
                
            case ORDER_STATUS_220:
                title = @"装货在途";
                break;
                
            case ORDER_STATUS_226:
                title = @"待入厂";
                break;
                
            case ORDER_STATUS_228:
                title = @"装货中";
                break;
                
            case ORDER_STATUS_230:
                title = @"送货在途";
                break;
                
            case ORDER_STATUS_238:
                title = @"送货在途";
                break;
                
            case ORDER_STATUS_240:
                title = @"送货在途";
                break;
                
            default:
                break;
        }
    }
    
    return title;
}

//获取BACK回空签到时描述
+ (NSString *)getOrderDescriptionWithStatus:(NSInteger)status orderType:(NSString *)orderType {
    NSString *decStr = @"";
    if ([orderType isEqualToString:ORDER_TYPE_BACK]) {
        switch (status) {
            case ORDER_STATUS_212:
                decStr = @"";
                break;
                
            case ORDER_STATUS_220:
                decStr = @"您已开始运输，请在到达装货地址点击下方按钮！";
                break;
                
            case ORDER_STATUS_226:
                decStr = @"您已到达装货地，请在入厂装货时点击下方按钮！";
                break;
                
            case ORDER_STATUS_228:
                decStr = @"请您进厂装货，请装货完成后点击下方按钮！";
                break;
                
            case ORDER_STATUS_230:
                decStr = @"您好，您的回空单已装货完成，请您在到达卸货地点时点击下方按钮！";
                break;
                
            case ORDER_STATUS_238:
                decStr = @"您好，您已到达卸货地址，请在入厂卸货时点击下方按钮！";
                break;
                
            case ORDER_STATUS_240:
                decStr = @"您已开始卸货中，请在卸货完成后点击下方按钮！";
                break;
                
            default:
                break;
        }
    } else if ([orderType isEqualToString:ORDER_TYPE_COMMON]) {
        switch (status) {
            case ORDER_STATUS_212:
                decStr = @"";
                break;
                
            case ORDER_STATUS_220:
                decStr = @"您已开始运输，请按时到厂装货！请在到达装货地址后点击下方按钮！";
                break;
                
            case ORDER_STATUS_226:
                decStr = @"您已签到成功，请在进厂装货时点击如下按钮！";
                break;
                
            case ORDER_STATUS_228:
                decStr = @"请您入厂正在装货，请在装货完成出厂后点击如下按钮！";
                break;
                
            case ORDER_STATUS_230:
                decStr = @"您已装货完成出厂，请您安全驾驶，请在到达收货地后点击“收货签到”！";
                break;
                
            case ORDER_STATUS_238:
                decStr = @"您已到达卸货地址，请在入厂卸货时点击如下按钮！";
                break;
                
            case ORDER_STATUS_240:
                decStr = @"您已开始卸货，请在卸货完成后点击如下按钮！";
                break;
                
            default:
                break;
        }
    }
    return decStr;
}


//根据订单类型和当前订单状态,获取下一步订单状态
+ (NSInteger)getNextProcessWithCurrentStatus:(NSInteger)currentStatus orderType:(NSString *)orderType {
    if ([orderType isEqualToString:ORDER_TYPE_KA]) {
        switch (currentStatus) {
            case ORDER_STATUS_212:  //待接收
            {
                return ORDER_STATUS_220;
            }
                break;
                
            case ORDER_STATUS_220: //开始运输
            {
                return ORDER_STATUS_226;
            }
                break;
                
            case ORDER_STATUS_226:  //装货签到
            {
                return ORDER_STATUS_228;
            }
                break;
                
            case ORDER_STATUS_228:  //装货入厂
            {
                return ORDER_STATUS_230;
            }
                break;
                
            case ORDER_STATUS_230:  //装货离厂
            {
                return ORDER_STATUS_238;
            }
                break;
                
            case ORDER_STATUS_238:  //收货签到
            {
                return ORDER_STATUS_240;
            }
                break;
                
            case ORDER_STATUS_240:  //收货入厂
            {
                return ORDER_STATUS_245;
            }
                break;
                
            default:
                break;
        }
    } else if ([orderType isEqualToString:ORDER_TYPE_COMMON]) {
        
    } else if ([orderType isEqualToString:ORDER_TYPE_BACK]) {
        switch (currentStatus) {
            case ORDER_STATUS_212:
            {
                return ORDER_STATUS_220;
            }
                break;
                
            case ORDER_STATUS_220:
            {
                return ORDER_STATUS_226;
            }
                break;
                
            case ORDER_STATUS_226:
            {
                return ORDER_STATUS_228;
            }
                break;
                
            case ORDER_STATUS_228:
            {
                return ORDER_STATUS_230;
            }
                break;
                
            case ORDER_STATUS_230:
            {
                return ORDER_STATUS_238;
            }
                break;
                
            case ORDER_STATUS_238:
            {
                return ORDER_STATUS_240;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

//获取订单类型名称
+ (NSString *)getOrderTypeDesStringWithOrderTyoe:(NSString *)orderType {
    if ([orderType isEqualToString:ORDER_TYPE_KA]) {
        return @"KA";
    } else if ([orderType isEqualToString:ORDER_TYPE_BACK]) {
        return @"回瓶";
    }
    return @"常规";
}

@end
