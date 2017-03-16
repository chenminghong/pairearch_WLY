//
//  GetRefuseFooterView.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetRefuseFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *checkBtuton;  //确认按钮
@property (weak, nonatomic) IBOutlet UIButton *refuseButton; //拒绝按钮


//初始化
+ (GetRefuseFooterView *)getFooterView;

@end
