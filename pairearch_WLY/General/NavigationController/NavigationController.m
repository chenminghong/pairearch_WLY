//
//  NavigationController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    
    self.navigationBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [[self class] getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [super pushViewController:viewController animated:animated];
}

//获取返回按钮
+ (UIBarButtonItem *)getNavigationBackItemWithTarget:(id)target SEL:(SEL)sel {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 18, 18);
    [backBtn setImage:[UIImage imageNamed:@"fanhui_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}

- (void)popBackAction:(UIBarButtonItem *)back {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
