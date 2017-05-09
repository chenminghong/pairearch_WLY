//
//  RootTabController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RootTabController.h"

#import "HomeViewController.h"
#import "OrdersCenterController.h"
#import "NotificationCenterController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"

@interface RootTabController ()

@end

@implementation RootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //先初始化登录用户信息数据
    [[LoginModel shareLoginModel] initData];
    
    UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"HomeViewController" bundle:nil];
    HomeViewController *homeVC = [homeSB instantiateViewControllerWithIdentifier:@"HomeViewController"];
    NavigationController *homeNC = [self addNavigationItemForViewController:homeVC];
    
    UIStoryboard *orderSB = [UIStoryboard storyboardWithName:@"OrdersCenterController" bundle:nil];
    OrdersCenterController *orderVC = [orderSB instantiateViewControllerWithIdentifier:@"OrdersCenterController"];
    NavigationController *orderNC = [self addNavigationItemForViewController:orderVC];
    
    PersonalCenterViewController *privateVC = [PersonalCenterViewController new];
    NavigationController *privateNC = [self addNavigationItemForViewController:privateVC];
    
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    self.viewControllers = @[homeNC, orderNC, privateNC];
    
    NSArray *titles = @[@"首页", @"运单中心", @"我的"];
    NSArray *images = @[@"zhuye", @"yundanzhongxin", @"gerenzhongxin"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:[images[idx] stringByAppendingString:@"-sel"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_THEME_COLOR} forState:UIControlStateSelected];
    }];
}

#pragma mark -- Navigation

- (NavigationController *)addNavigationItemForViewController:(UIViewController *)viewController {
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    navigationController.hidesBottomBarWhenPushed = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
//    navigationController.interactivePopGestureRecognizer.delegate = self;
    return navigationController;
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
