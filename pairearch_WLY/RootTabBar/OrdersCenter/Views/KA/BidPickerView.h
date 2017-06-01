//
//  BidPickerView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BidSelectView;

typedef void(^SelectBlock)(id model);

@interface BidPickerView : UIView

@property (nonatomic, strong) UIView *shadowView;  //背景遮盖

@property (nonatomic, strong) BidSelectView *selectView;  //选择视图

@property (nonatomic, copy) SelectBlock selectBlock;  //确定按钮点击回调

/**
 显示视图
 
 @param title 顶部标签
 @param dataArr 数据源
 @param selectBlock 选中回调
 @return 返回当前视图对象
 */
+ (BidPickerView *)showSelectViewWithTitle:(NSString *)title dataArr:(NSArray *)dataArr selectBlock:(SelectBlock)selectBlock;

@end
