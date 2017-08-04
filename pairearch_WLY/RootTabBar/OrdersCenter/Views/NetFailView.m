
//
//  NetFailView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/8/4.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NetFailView.h"

@implementation NetFailView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

+ (NetFailView *)getFailViewWithSuperview:(UIView *)view repeatBlock:(RepeatActionBlock)block {
    NetFailView *failView = [[[NSBundle mainBundle] loadNibNamed:@"NetFailView" owner:self options:nil] firstObject];
    failView.frame = view.bounds;
    [view addSubview:failView];
    failView.repeatBlock = block;
    return failView;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
    if (self.repeatBlock) {
        self.repeatBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
