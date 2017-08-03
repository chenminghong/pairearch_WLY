//
//  CommonSelectStateController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonSelectStateController.h"

#import "DetailCommonModel.h"
#import "OrderStatusCOMMON230Controller.h"
#import "OrderStatusCOMMON212Controller.h"
#import "OrderStatusCOMMON220Controller.h"
#import "OrderStatusCOMMON226Controller.h"
#import "OrderStatusCOMMON228Controller.h"
#import "OrderStatusKA245Controller.h"


@interface CommonSelectStateController ()

@property (nonatomic, strong) NSMutableArray *dataListArr;  //数据源

@end

@implementation CommonSelectStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    
    self.orderType = ORDER_TYPE_COMMON;
}

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
    
    [self loadDetailDataFromNet];
}


//网络请求数据
- (void)loadDetailDataFromNet {
    [DetailCommonModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
            [self judgeJumpToDetailController];
        } else {
            MBProgressHUD *hud = [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            [hud setCompletionBlock:^(){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}

/**
 获取状态码最小的数据模型
 
 @param modelList 当前负载单中交货单列表
 @return 最小状态码所对应的交货单数据模型
 */
- (DetailCommonModel *)getMinStatusWithModels:(NSArray<DetailCommonModel *>*)modelList {
    DetailCommonModel *model = nil;
    NSInteger minStatus = 1000;
    for (DetailCommonModel *tempModel in modelList) {
        if (tempModel.SHPM_STATUS.integerValue < minStatus) {
            model = tempModel;
            minStatus = tempModel.SHPM_STATUS.integerValue;
        }
    }
    return model;
}

//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailController {
    DetailCommonModel *model = [self getMinStatusWithModels:self.dataListArr];
    NSInteger orderStatus = [model.SHPM_STATUS integerValue];
    if (orderStatus > ORDER_STATUS_240) {
        orderStatus = ORDER_STATUS_245;
    }
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:ORDER_TYPE_KA];
    
    switch (orderStatus) {
        case ORDER_STATUS_212:
        {
            OrderStatusCOMMON212Controller *childVC = [OrderStatusCOMMON212Controller new];
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_220:
        {
            OrderStatusCOMMON220Controller *childVC = [OrderStatusCOMMON220Controller new];
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_226:
        {
            OrderStatusCOMMON226Controller *childVC = [OrderStatusCOMMON226Controller new];
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_228:
        {
            OrderStatusCOMMON228Controller *childVC = [OrderStatusCOMMON228Controller new];
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_230:
        case ORDER_STATUS_238:
        case ORDER_STATUS_240:
        {
            OrderStatusCOMMON230Controller *childVC = [OrderStatusCOMMON230Controller new];
            childVC.paraDict = self.paraDict;
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
            childVC.nextBlock = ^(NSDictionary *paraDict) {
                [self loadDetailDataFromNet];
            };
        }
            break;
            
        case ORDER_STATUS_245:
        {
            self.title = @"服务评价";
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
    CommonSelectStateController *nextVC = [CommonSelectStateController new];
    nextVC.paraDict = self.paraDict;
    [self.navigationController pushViewController:nextVC animated:YES];
}


//添加子视图控制器
- (void)addChildController:(UIViewController *)viewController {
    if (self.childViewControllers.count > 0) {
        if ([[self.childViewControllers[0] class] isSubclassOfClass:[viewController class]]) {
            return;
        }
        [self addChildViewController:viewController];
        viewController.view.frame = self.view.bounds;
        
        [UIView transitionFromView:self.view.subviews[0] toView:viewController.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            if (finished) {
                [self.childViewControllers[0] removeFromParentViewController];
            }
        }];
    } else {
        [self addChildViewController:viewController];
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            viewController.view.frame = self.view.bounds;
            [self.view insertSubview:viewController.view atIndex:0];
        } completion:nil];
    }
    
    /*
    if (self.childViewControllers.count > 0) {
        [self.view.subviews[0] removeFromSuperview];
        [self.childViewControllers[0] removeFromParentViewController];
        
    }
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view insertSubview:viewController.view atIndex:0];
     */
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

//返回按钮点击事件
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
