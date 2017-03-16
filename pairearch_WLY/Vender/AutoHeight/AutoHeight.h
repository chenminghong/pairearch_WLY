//
//  AutoHeight.h
//  豆瓣
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AutoHeight : NSObject
+ (CGFloat)weightForContent:(NSString *)content Height:(CGFloat)height Font:(UIFont *)font;
+ (CGFloat)heightForContent:(NSString *)content Width:(CGFloat)width Font:(UIFont *)font;
@end
