//
//  AutoHeight.m
//  豆瓣
//
//  Created by dllo on 15/9/15.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "AutoHeight.h"

@implementation AutoHeight
+ (CGFloat)weightForContent:(NSString *)content Height:(CGFloat)height Font:(UIFont *)font
{
    CGSize size = CGSizeMake(1000, height);
    
    //字体大小要和contentsLabel.text的字体大小一致
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    //有返回值CGRect      NSStringDrawingUsesLineFragmentOrigin
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.width;
}
+ (CGFloat)heightForContent:(NSString *)content Width:(CGFloat)width Font:(UIFont *)font
{
    CGSize size = CGSizeMake(width, 10000);
    
    //字体大小要和contentsLabel.text的字体大小一致
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    //有返回值CGRect      NSStringDrawingUsesLineFragmentOrigin
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.height;
}
@end
