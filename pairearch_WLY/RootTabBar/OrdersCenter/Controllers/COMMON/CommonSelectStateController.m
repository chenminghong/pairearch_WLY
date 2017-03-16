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
            
                //根据加载的数据判断跳转界面
            [self judgeJumpToDetailController];
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}

//根据加载的数据判断跳转界面
- (void)judgeJumpToDetailController {
    DetailCommonModel *model = self.dataListArr[0];
    NSInteger status = [model.SHPM_STATUS integerValue];
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:status orderType:ORDER_TYPE_KA];
    switch (status) {
        case ORDER_STATUS_230:
        {
            OrderStatusCOMMON230Controller *childVC = [OrderStatusCOMMON230Controller new];
            childVC.paraDict = self.paraDict;
            childVC.orderStatus = status;
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
        }
            break;
        default:
        {
            OrderStatusCOMMON230Controller *childVC = [OrderStatusCOMMON230Controller new];
            childVC.paraDict = self.paraDict;
            childVC.orderStatus = status;
            childVC.dataListArr = self.dataListArr;
            [self addChildController:childVC];
        }
            break;
    }
}


//添加子视图控制器
- (void)addChildController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view insertSubview:viewController.view atIndex:0];
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
