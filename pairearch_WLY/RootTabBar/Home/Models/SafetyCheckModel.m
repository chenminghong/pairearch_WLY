//
//  SafetyCheckModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SafetyCheckModel.h"

@implementation SafetyCheckModel

+ (NSArray *)getModelArray {
    NSArray *dataArr = @[@"穿戴好安全帽、反光背心、劳保鞋",
                         @"装车前已使用轮阻垫好轮胎",
                         @"关闭电源，钥匙插在门上",
                         @"在等候区等候，不随意走动",
                         @"车内有灭火器，三脚架",
                         @"车厢内整洁没有杂物、油污、异味",
                         @"灯、安全帽、离合、刹车等正常",
                         @"驾驶前司机带好安全带",
                         @"没有超过额定载荷",
                         @"驾照、合格证、通行证有效正常"];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArr.count; i++) {
        NSDictionary *dataDict = @{@"safetyStr":dataArr[i],
                                   @"selected":@0};
        SafetyCheckModel *model = [SafetyCheckModel getModelWithDict:dataDict];
        [modelArr addObject:model];
    }
    return modelArr;
}

@end
