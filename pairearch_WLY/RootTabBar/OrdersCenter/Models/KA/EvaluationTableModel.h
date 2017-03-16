//
//  EvaluationTableModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface EvaluationTableModel : BaseModel

@property (nonatomic, copy) NSString *statementStr; //分值项目

@property (nonatomic, copy) NSString *key;          //分值关键字

@property (nonatomic, copy) NSString *score;        //当前的分值

+ (NSArray *)getModelArray;

@end
