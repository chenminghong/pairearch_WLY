//
//  SafetyCheckModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafetyCheckModel : BaseModel

@property (nonatomic, strong) NSNumber *selected;

@property (nonatomic, copy) NSString *safetyStr;

+ (NSArray *)getModelArray;

@end
