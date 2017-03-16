//
//  CommonPickerView.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerViewBlock)(NSString *reasonTitle);

@interface CommonPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) PickerViewBlock pickBlock;

@property (nonatomic, strong) NSArray *dataList;  //数据源

//显示选择栏
+ (CommonPickerView *)showPickerViewInView:(UIView *)view titleList:(NSArray *)titleList pickBlock:(PickerViewBlock)pickBlock;

//隐藏选择栏
- (void)hidePickerView;

@end
