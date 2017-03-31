//
//  LoginViewController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController

//判断是否登录
+ (BOOL)isLogin;

//模态出登录界面
+ (void)showSelfInController:(UIViewController *)controller completeBlock:(void (^)())completeBlock;

@end
