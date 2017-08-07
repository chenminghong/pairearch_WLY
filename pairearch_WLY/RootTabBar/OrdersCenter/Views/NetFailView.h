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

@property (nonatomic, strong) NSInvocation *invocation;



/**
 请求失败页面

 @param view 需要添加的界面（父视图）
 @param block 点击屏幕事件
 @return 返回当前的视图
 */
+ (NetFailView *)showFailViewInView:(UIView *)view repeatBlock:(RepeatActionBlock)block;


/**
 请求失败，点击重试

 @param view 失败视图需要加载的界面
 @param target 方法实现所在的类
 @param action 需要重新执行的方法
 @param arguments 执行方法需要的参数
 @return 返回当前创建的视图
 */
+ (NetFailView *)showFailViewInView:(UIView *)view target:(id)target action:(SEL)action arguments:(NSArray *)arguments;

@end
