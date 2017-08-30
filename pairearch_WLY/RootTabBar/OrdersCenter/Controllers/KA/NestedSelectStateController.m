//
//  NestedSelectStateController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NestedSelectStateController.h"

#import "OrderStatusKA230Controller.h"
#import "OrderDetailModel.h"
#import "OrderStatusKA230Controller.h"
#import "OrderStatusKA238Controller.h"
#import "OrderStatusKA240Controller.h"
#import "OrderStatusKA245Controller.h"

#import "OrderStatusKA212Controller.h"
#import "OrderStatusKA220Controller.h"
#import "OrderStatusKA226Controller.h"
#import "OrderStatusKA228Controller.h"


@interface NestedSelectStateController ()

@property (nonatomic, strong) NSMutableArray *dataListArr;  //数据源

@end

@implementation NestedSelectStateController


#pragma mark -- LazyLoading

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
}

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
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
    
    [OrderDetailModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            NSArray *dataListArr = [NSMutableArray arrayWithArray:model];
            NSMutableDictionary *orderCodeDict = [NSMutableDictionary dictionary];
            for (OrderDetailModel *detailModel in dataListArr) {
                [orderCodeDict setObject:detailModel forKey:detailModel.ORDER_CODE];
            }
            
            NSArray *orderCodeArr = [orderCodeDict allKeys];  //获取所有的orderCode
            self.dataListArr = [NSMutableArray array];
            for (NSString *orderCode in orderCodeArr) {
                NSMutableArray *modelArr = [NSMutableArray array];
                for (OrderDetailModel *model in dataListArr) {
                    if ([orderCode isEqualToString:model.ORDER_CODE]) {
                        [modelArr addObject:model];
                    }
                }
                [self.dataListArr addObject:modelArr];
            }
            
            //根据加载的数据判断跳转界面
            OrderDetailModel *model = [self getMinStatusWithModels:self.dataListArr];
            NSInteger status = model.SHPM_STATUS.integerValue;
            if (status > ORDER_STATUS_240) {
                status = ORDER_STATUS_245;
            }
            [self judgeJumpToDetailControllerWithOrderStatus:status];
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
- (OrderDetailModel *)getMinStatusWithModels:(NSArray<NSArray *>*)modelList {
    OrderDetailModel *model = nil;
    NSInteger minStatus = 1000;
    for (NSArray *modelArr in modelList) {
        for (OrderDetailModel *tempModel in modelArr) {
            if (tempModel.SHPM_STATUS.integerValue < minStatus) {
                model = tempModel;
                minStatus = tempModel.SHPM_STATUS.integerValue;
            }
        }
    }
    return model;
}

//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailControllerWithOrderStatus:(NSInteger)orderStatus {
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:ORDER_TYPE_KA];
    switch (orderStatus) {
        case ORDER_STATUS_212:
        {
            OrderStatusKA212Controller *childVC = [OrderStatusKA212Controller new];
            [self addChildController:childVC];
            childVC.dataListArr = self.dataListArr;
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_220:
        {
            OrderStatusKA220Controller *childVC = [OrderStatusKA220Controller new];
            [self addChildController:childVC];
            childVC.dataListArr = self.dataListArr;
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_226:
        {
            OrderStatusKA226Controller *childVC = [OrderStatusKA226Controller new];
            [self addChildController:childVC];
            childVC.dataListArr = self.dataListArr;
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_228:
        {
            OrderStatusKA228Controller *childVC = [OrderStatusKA228Controller new];
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
            
        case ORDER_STATUS_230:
        {
            OrderStatusKA230Controller *childVC = [OrderStatusKA230Controller new];
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_238:
        {
            OrderStatusKA238Controller *childVC = [OrderStatusKA238Controller new];
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_240:
        case ORDER_STATUS_241:
            
        {
            OrderStatusKA240Controller *childVC = [OrderStatusKA240Controller new];
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_245:
        {
            OrderStatusKA245Controller *evaluationVC = [OrderStatusKA245Controller new];
            evaluationVC.paraDict = self.paraDict;
            [self addChildController:evaluationVC];
        }
            break;
            
        default:
            break;
    }
    
    
}

//跳转到下一个界面
- (void)pushToNextWithParaDict:(NSDictionary *)paraDict {
    NestedSelectStateController *nextVC = [NestedSelectStateController new];
    nextVC.paraDict = self.paraDict;
    [self.navigationController pushViewController:nextVC animated:YES];
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

#pragma mark -- ButtonAction

//返回按钮
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
