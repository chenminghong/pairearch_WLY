//
//  FuctionUtil.h
//  iFuWoiPhone
//
//  Created by WEICHANG CHEN on 16/7/4.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuctionUtil : NSObject

// 判断字符是否为空
+(BOOL)isNull:(NSString*)str;
//转化时间
+ (NSString *)compareCurrentTime:(NSString *)dateString;

/** 通过行数, 返回更新时间 */
+ (NSString *)updateTimeForRow:(NSInteger)row;
+ (NSString *)getStringSub:(NSString *)string;
//判断是否为表情符号
+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
