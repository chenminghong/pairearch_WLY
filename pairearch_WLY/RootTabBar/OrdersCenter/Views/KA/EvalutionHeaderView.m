//
//  EvalutionHeaderView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EvalutionHeaderView.h"

@implementation EvalutionHeaderView

#pragma mark -- LazyLoding

- (UILabel *)labelOne {
    if (!_labelOne) {
        self.labelOne = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth - 60, (CGRectGetHeight(self.bounds) - 20) / 2)];
        self.labelOne.font = [UIFont systemFontOfSize:14.0];
        self.labelOne.text = @"您好，你已送货完成，祝您一路平安！";
    }
    return _labelOne;
}

- (UILabel *)labelTwo {
    if (!_labelTwo) {
        self.labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.labelOne.frame), CGRectGetWidth(self.labelOne.bounds), (CGRectGetHeight(self.bounds) - 20) / 2)];
        self.labelTwo.font = [UIFont systemFontOfSize:14.0];
        self.labelTwo.text = @"请您对工厂的服务做出评价：";
    }
    return _labelTwo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.labelOne];
        [self addSubview:self.labelTwo];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
