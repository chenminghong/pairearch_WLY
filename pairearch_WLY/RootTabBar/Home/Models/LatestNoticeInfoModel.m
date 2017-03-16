//
//  LatestNoticeInfoModel.m
//  WLY
//
//  Created by Leo on 16/3/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LatestNoticeInfoModel.h"

@implementation LatestNoticeInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}
@end
