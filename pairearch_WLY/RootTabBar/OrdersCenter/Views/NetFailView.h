//
//  NetFailView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/8/4.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RepeatActionBlock)();

@interface NetFailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *failImageV;
@property (weak, nonatomic) IBOutlet UILabel *failTipsLabel;

@property (nonatomic, copy) RepeatActionBlock repeatBlock;



/**
 请求失败页面

 @param view 需要添加的界面（父视图）
 @param block 点击屏幕事件
 @return 返回当前的视图
 */
+ (NetFailView *)getFailViewWithSuperview:(UIView *)view repeatBlock:(RepeatActionBlock)block;

@end
