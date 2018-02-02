
//
//  BACKNestedSelectController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BACKNestedSelectController.h"

#import "BackDetailModel.h"
#import "OrderStatusBACK212Controller.h"
#import "OrderStatusBACK220Controller.h"
#import "OrderStatusBACK226Controller.h"
#import "OrderStatusBACK228Controller.h"
#import "OrderStatusBACK230Controller.h"
#import "OrderStatusBACK238Controller.h"
#import "OrderStatusBACK240Controller.h"


@interface BACKNestedSelectController ()

@property (nonatomic, strong) NSMutableArray *dataListArr;  //数据源

@end

@implementation BACKNestedSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
}

- (void)setParaDict:(NSMutableDictionary *)paraDict {
    _paraDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
    [self loadDetailDataFromNet];
}

//网络请求数据
- (void)loadDetailDataFromNet {
//    if (self.childViewControllers.count > 0) {
//        for (UIViewController *childVC in self.childViewControllers) {
//            [childVC.view removeFromSuperview];
//            [childVC removeFromParentViewController];
//        }
//    }
    [BackDetailModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
            BackDetailModel *model = [self getMinStatusWithModels:self.dataListArr];
            NSInteger status = [model.SHPM_STATUS integerValue];
            if (status > ORDER_STATUS_240) {
                status = model.STATUS.integerValue;
            }
            //根据加载的数据判断跳转界面
            [self judgeJumpToDetailControllerWithStatus:status];
        } else {
            //添加请求失败视图
            [NetFailView showFailViewInView:self.view repeatBlock:^{
                [self loadDetailDataFromNet];
            }];
            
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}


/**
 获取状态码最小的数据模型

 @param modelList 当前负载单中交货单列表
 @return 最小状态码所对应的交货单数据模型
 */
- (BackDetailModel *)getMinStatusWithModels:(NSArray<BackDetailModel *>*)modelList {
    BackDetailModel *model = nil;
    NSInteger minStatus = 1000;
    for (BackDetailModel *tempModel in modelList) {
        if (tempModel.SHPM_STATUS.integerValue < minStatus) {
            model = tempModel;
            minStatus = tempModel.SHPM_STATUS.integerValue;
        }
    }
    return model;
}

/**
 获取订单状态
 */
/*
- (void)getOrderStatus {
    [NetworkHelper GET:ORDER_STATUS_API parameters:self.paraDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:NO];
        NSLog(@"%@", responseObject);
        NSString *result = responseObject[@"result"];
        if (result.integerValue == 1) {
            NSInteger status = [responseObject[@"status"] integerValue];
            if (status < ORDER_STATUS_230) {
                [self judgeJumpToDetailControllerWithStatus:status];
            } else {
                
            }
        } else {
            [self removeChildController:nil];
            [ProgressHUD bwm_showTitle:@"" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    } failure:^(NSError *error) {
        [self removeChildController:nil];
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}
*/

//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailControllerWithStatus:(NSInteger)status {
    NSString *title = self.paraDict[@"title"];
    if (title.length > 0) {
        self.title = title;
        [self.paraDict removeObjectForKey:@"title"];
    } else {
        self.title = [OrderStatusManager getStatusTitleWithOrderStatus:status orderType:ORDER_TYPE_BACK];
    }
    switch (status) {
        case ORDER_STATUS_212:
        {
            OrderStatusBACK212Controller *childVC = [OrderStatusBACK212Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_220:
        {
            OrderStatusBACK220Controller *childVC = [OrderStatusBACK220Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_226:
        {
            OrderStatusBACK226Controller *childVC = [OrderStatusBACK226Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_228:
        {
            OrderStatusBACK228Controller *childVC = [OrderStatusBACK228Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_230:
        {
            OrderStatusBACK230Controller *childVC = [OrderStatusBACK230Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_238:
        {
            OrderStatusBACK238Controller *childVC = [OrderStatusBACK238Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                [self loadDetailDataFromNet];
            }];
        }
            break;
            
        case ORDER_STATUS_240:
        {
            OrderStatusBACK240Controller *childVC = [OrderStatusBACK240Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            [childVC setNextBlock:^(NSDictionary *paraDict){
                if ([paraDict[@"pop"] boolValue]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self loadDetailDataFromNet];
                }
            }];
        }
            break;
            
        default:
        {
            if (status > ORDER_STATUS_245) {
                [ProgressHUD bwm_showTitle:@"该订单已结束！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL / 2.0];
            }
        }
            break;
    }
}

//添加子视图控制器
- (void)addChildController:(UIViewController *)viewController {
    if (self.childViewControllers.count > 0) {
        [[self.childViewControllers lastObject] removeFromParentViewController];
        [self addChildViewController:viewController];
        viewController.view.frame = self.view.bounds;
        [UIView transitionFromView:[self.view.subviews lastObject] toView:viewController.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    } else {
        [self addChildViewController:viewController];
        viewController.view.frame = self.view.bounds;
        [self.view addSubview:viewController.view];
    }
}

//移除子视图控制器
- (void)removeChildController:(UIViewController *)viewController {
    if (viewController) {
        [viewController removeFromParentViewController];
        [viewController.view removeFromSuperview];
    } else {
        for (UIViewController *childController in self.childViewControllers) {
            [childController.view removeFromSuperview];
            [childController removeFromParentViewController];
        }
    }
}

#pragma mark -- ButtonAction

//返回按钮
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 跳转到下一个界面
 */
- (void)pushToNextVC {
    BACKNestedSelectController *nestedVC = [BACKNestedSelectController new];
    nestedVC.paraDict = self.paraDict;
    [self.navigationController pushViewController:nestedVC animated:YES];
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
