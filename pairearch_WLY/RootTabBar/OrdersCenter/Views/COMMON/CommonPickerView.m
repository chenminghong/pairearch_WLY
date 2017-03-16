//
//  CommonPickerView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonPickerView.h"

@implementation CommonPickerView

+ (CommonPickerView *)getPickerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommonPickerView" owner:self options:nil] firstObject];
}

+ (CommonPickerView *)showPickerViewInView:(UIView *)view titleList:(NSArray *)titleList pickBlock:(PickerViewBlock)pickBlock {
    UIView *view1 = [[UIView alloc] initWithFrame:view.bounds];
    [view addSubview:view1];
    
    CommonPickerView *pickerView = [self getPickerView];
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.frame = view.bounds;
    pickerView.pickerView.backgroundColor = ABNORMAL_THEME_COLOR;
    pickerView.pickBlock = pickBlock;
    pickerView.dataList = titleList;
    [pickerView.pickerView reloadAllComponents];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(hidePickerView)];
    [pickerView addGestureRecognizer:tap];

    [UIView transitionFromView:view1 toView:pickerView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    
    return pickerView;
}

- (void)hidePickerView {
    UIView *view1 = [[UIView alloc] initWithFrame:self.bounds];
    
    [UIView transitionFromView:self toView:view1 duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        if (finished) {
            [view1 removeFromSuperview];
        }
    }];
}




#pragma mark -- Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickBlock) {
        self.pickBlock(self.dataList[row]);
        [self hidePickerView];
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
