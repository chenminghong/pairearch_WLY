//
//  BidPickerView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BidPickerView.h"

#import "BidSelectView.h"

#define K_ANIMATION_TIMEINTERVAL 0.2
#define K_TIME_PICKERVIEW_HEIGHT  300.0

@implementation BidPickerView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title dataArr:(NSArray *)dataArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shadowView];
        [UIView animateWithDuration:K_ANIMATION_TIMEINTERVAL animations:^{
            self.shadowView.alpha = 0.5;
        }];
        
        __weak typeof(self) weakSelf = self;
        self.selectView = [BidSelectView showInView:self frame:CGRectMake(0.0, kScreenHeight - K_TIME_PICKERVIEW_HEIGHT, kScreenWidth, K_TIME_PICKERVIEW_HEIGHT) animationDuraton:K_ANIMATION_TIMEINTERVAL title:title dataArr:dataArr selectBlock:^(id model) {
            [weakSelf hide];
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(model);
            }
        }];
    }
    return self;
}


- (UIView *)shadowView {
    if (!_shadowView) {
        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

/**
 背景遮罩手势
 */
- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self hide];
}

/**
 显示视图

 @param title 顶部标签
 @param dataArr 数据源
 @param selectBlock 选中回调
 @return 返回当前视图对象
 */
+ (BidPickerView *)showSelectViewWithTitle:(NSString *)title dataArr:(NSArray *)dataArr selectBlock:(SelectBlock)selectBlock {
    BidPickerView *pickerView = [[BidPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds title:title dataArr:dataArr];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:pickerView];
    pickerView.selectBlock = selectBlock;
    return pickerView;
}

/**
 隐藏视图
 */
- (void)hide {
    [self.selectView hide];
    [UIView animateWithDuration:K_ANIMATION_TIMEINTERVAL animations:^{
        self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
