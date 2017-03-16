//
//  GetRefuseFooterView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "GetRefuseFooterView.h"

@implementation GetRefuseFooterView

+ (GetRefuseFooterView *)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"GetRefuseFooterView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
