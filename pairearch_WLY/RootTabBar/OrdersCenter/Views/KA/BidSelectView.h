//
//  BidSelectView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SureButtonBlock)(id selectModel);

@interface BidSelectView : UIView<UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, assign) NSTimeInterval animationTimeInterval;  //动画持续时间间隔

@property (nonatomic, strong) id selectModel;  //选中的标题

@property (nonatomic, strong) NSArray *dataArr;   //数据源

@property (nonatomic, copy) SureButtonBlock sureBlock;   //选择按钮回调


/**
 初始化视图
 */
+ (instancetype)getBidSelectView;

/**
 显示时间选择器视图。
 */
+ (BidSelectView *)showInView:(UIView *)view frame:(CGRect)frame animationDuraton:(NSTimeInterval)duration title:(NSString *)title dataArr:(NSArray *)dataArr selectBlock:(SureButtonBlock)sureBlock;


/**
 隐藏
 */
- (void)hide;

@end
