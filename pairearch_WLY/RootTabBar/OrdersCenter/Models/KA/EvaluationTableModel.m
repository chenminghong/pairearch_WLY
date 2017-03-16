//
//  EvaluationTableModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EvaluationTableModel.h"

@implementation EvaluationTableModel

+ (NSArray *)getModelArray {
    NSArray *dataArr = @[@"1.工厂的处理效率满意度",
                         @"2.工厂的处理态度满意度",
                         @"3.装货的处理流程满意度"];
    NSArray *keyArr = @[@"factoryTe", @"factorySa", @"loadTs"];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArr.count; i++) {
        NSDictionary *dataDict = @{@"statementStr":dataArr[i],
                                   @"key":keyArr[i],
                                   @"score":@"0"};
        EvaluationTableModel *model = [EvaluationTableModel getModelWithDict:dataDict];
        [modelArr addObject:model];
    }
    return modelArr;
}

@end
