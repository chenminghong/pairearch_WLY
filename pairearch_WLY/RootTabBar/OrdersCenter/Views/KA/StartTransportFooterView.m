//
//  StartTransportFooterView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "StartTransportFooterView.h"

@implementation StartTransportFooterView

+ (StartTransportFooterView *)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:@"StartTransportFooterView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
