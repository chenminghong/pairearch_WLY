
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
    
    self.failTipsLabel.textColor = UIColorFromRGB(0x979797);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

+ (NetFailView *)showFailViewInView:(UIView *)view repeatBlock:(RepeatActionBlock)block {
    NetFailView *failView = [[[NSBundle mainBundle] loadNibNamed:@"NetFailView" owner:self options:nil] firstObject];
    failView.frame = view.bounds;
    [view addSubview:failView];
    failView.repeatBlock = block;
    return failView;
}

+ (NetFailView *)showFailViewInView:(UIView *)view target:(id)target action:(SEL)action arguments:(NSArray *)arguments {
    NetFailView *failView = [[[NSBundle mainBundle] loadNibNamed:@"NetFailView" owner:self options:nil] firstObject];
    failView.frame = view.bounds;
    [view addSubview:failView];
    
    NSMethodSignature *signature = [failView methodSignatureForSelector:action];
    failView.invocation = [NSInvocation invocationWithMethodSignature:signature];
    failView.invocation.target = target;
    failView.invocation.selector = action;
    for (NSInteger i = 0; i < arguments.count; i++) {
        id para = arguments[i];
        [failView.invocation setArgument:&para atIndex:i];
    }
    return failView;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
    if (self.invocation) {
        [self.invocation invoke];
    }
    
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
