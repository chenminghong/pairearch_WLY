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
#import "EarlyWarningController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
#import "NestedSelectStateController.h"
#import "BACKNestedSelectController.h"
#import "CommonSelectStateController.h"

@interface RootTabController ()

@property (nonatomic, strong) NSTimer *timer;

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
    
    EarlyWarningController *warningVC = [EarlyWarningController new];
    NavigationController *warningNC = [self addNavigationItemForViewController:warningVC];
    
    PersonalCenterViewController *privateVC = [PersonalCenterViewController new];
    NavigationController *privateNC = [self addNavigationItemForViewController:privateVC];
    
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    self.viewControllers = @[homeNC, orderNC, warningNC, privateNC];
    
    NSArray *titles = @[@"首页", @"运单中心", @"预警", @"我的"];
    NSArray *images = @[@"zhuye", @"yundanzhongxin", @"yujingzhongxin", @"gerenzhongxin"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:[images[idx] stringByAppendingString:@"-sel"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_THEME_COLOR} forState:UIControlStateSelected];
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:600 target:warningVC selector:@selector(getListDataBackground) userInfo:nil repeats:YES];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count >= 2) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    if (userInfo) {
        NSString *orderType = userInfo[@"transportCode"];
        if ([orderType isEqualToString:ORDER_TYPE_KA]) {
            [self jumpToKaControllerWithParaDict:userInfo];
        } else if ([orderType isEqualToString:ORDER_TYPE_COMMON]) {
            [self jumpToCommonControllerWithParaDict:userInfo];
        } else {
            [self jumpToBackControllerWithParaDict:userInfo];
        }
    }
}

/**
 重启定时器
 */
- (void)startTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}


/**
 暂停定时器
 */
- (void)stopTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark -- Navigation

- (NavigationController *)addNavigationItemForViewController:(UIViewController *)viewController {
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    navigationController.hidesBottomBarWhenPushed = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    return navigationController;
}

//KA界面跳转逻辑
- (void)jumpToKaControllerWithParaDict:(NSDictionary *)paraDict {
    NestedSelectStateController *nestedVC = [NestedSelectStateController new];
    [self.navigationController pushViewController:nestedVC animated:YES];
    nestedVC.paraDict = paraDict;
}

//BACK界面跳转逻辑
- (void)jumpToBackControllerWithParaDict:(NSDictionary *)paraDict{
    BACKNestedSelectController *backVC = [BACKNestedSelectController new];
    backVC.paraDict = paraDict;
    [self.navigationController pushViewController:backVC animated:YES];
}

//COMMON界面跳转逻辑
- (void)jumpToCommonControllerWithParaDict:(NSDictionary *)paraDict{
    CommonSelectStateController *nestedVC = [CommonSelectStateController new];
    [self.navigationController pushViewController:nestedVC animated:YES];
    nestedVC.paraDict = paraDict;
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
