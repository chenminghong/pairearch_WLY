//
//  ProgressHUD.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/3.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

+ (MBProgressHUD *)bwm_showTitle:(NSString *)title toView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond {
    NSString *tempTitle = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tempTitle.length > 0) {
        return [super bwm_showTitle:title toView:view hideAfter:afterSecond];
    }
    title = @"系统错误";
    return [super bwm_showTitle:title toView:view hideAfter:afterSecond];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
