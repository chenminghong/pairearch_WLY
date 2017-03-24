//
//  NavigationController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

//获取返回按钮
+ (UIBarButtonItem *)getNavigationBackItemWithTarget:(id)target SEL:(SEL)sel;

//隐藏底部线条
- (void)hideNavigationBarBottomLine;

@end
