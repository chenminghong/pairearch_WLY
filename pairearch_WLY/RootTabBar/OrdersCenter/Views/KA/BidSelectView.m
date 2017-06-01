//
//  BidSelectView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BidSelectView.h"

@implementation BidSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    ((UIView *)[self.pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor lightGrayColor];
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor lightGrayColor];
}

+ (instancetype)getBidSelectView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BidSelectView" owner:self options:nil] firstObject];
}


+ (BidSelectView *)showInView:(UIView *)view frame:(CGRect)frame animationDuraton:(NSTimeInterval)duration title:(NSString *)title dataArr:(NSArray *)dataArr selectBlock:(SureButtonBlock)sureBlock {
    BidSelectView *selectView = [self getBidSelectView];
    selectView.frame = frame;
    [view addSubview:selectView];
    selectView.animationTimeInterval = duration;
    selectView.topLabel.text = title;
    selectView.dataArr = dataArr;
    selectView.sureBlock = sureBlock;
    selectView.selectModel = dataArr[0];
    selectView.transform = CGAffineTransformMakeTranslation(0.0, frame.size.height);
    [UIView animateWithDuration:duration animations:^{
        selectView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:selectView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = selectView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    selectView.layer.mask = maskLayer;
    return selectView;
}


/**
 隐藏
 */
- (void)hide {
    CGRect frame = self.frame;
    [UIView animateWithDuration:self.animationTimeInterval animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.0, frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id model = self.dataArr[row];
    NSString *title = [NSString stringWithFormat:@"%@", [model valueForKey:@"name"]];
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectModel = self.dataArr[row];
}



/**
 确定按钮点击事件

 @param sender 确定按钮
 */
- (void)sureButtonAction:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock(self.selectModel);
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
