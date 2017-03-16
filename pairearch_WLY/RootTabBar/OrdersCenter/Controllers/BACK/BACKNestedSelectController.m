
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

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
    
    [self loadDetailDataFromNet];
}

//网络请求数据
- (void)loadDetailDataFromNet {
    [BackDetailModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
            
            //根据加载的数据判断跳转界面
            [self judgeJumpToDetailController];
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}

//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailController {
    BackDetailModel *model = self.dataListArr[0];
    NSInteger status = [model.SHPM_STATUS integerValue];
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:status orderType:ORDER_TYPE_KA];
    switch (status) {
        case ORDER_STATUS_212:
        {
            OrderStatusBACK212Controller *childVC = [OrderStatusBACK212Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_220:
        {
            OrderStatusBACK220Controller *childVC = [OrderStatusBACK220Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_226:
        {
            OrderStatusBACK226Controller *childVC = [OrderStatusBACK226Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_228:
        {
            OrderStatusBACK228Controller *childVC = [OrderStatusBACK228Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_230:
        {
            OrderStatusBACK230Controller *childVC = [OrderStatusBACK230Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_238:
        {
            OrderStatusBACK238Controller *childVC = [OrderStatusBACK238Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        case ORDER_STATUS_240:
        {
            OrderStatusBACK240Controller *childVC = [OrderStatusBACK240Controller new];
            childVC.dataListArr = self.dataListArr;
            childVC.orderType = ORDER_TYPE_BACK;
            childVC.orderStatus = status;
            childVC.paraDict = self.paraDict;
            [self addChildController:childVC];
        }
            break;
            
        default:
            break;
    }
}

//添加子视图控制器
- (void)addChildController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view insertSubview:viewController.view atIndex:0];
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
