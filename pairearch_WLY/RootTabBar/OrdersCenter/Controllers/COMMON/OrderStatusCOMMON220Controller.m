//
//  OrderStatusCOMMON220Controller.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusCOMMON220Controller.h"

#import "StartTransportFooterView.h"
#import "CommonConfirationCell.h"
#import "DetailCommonModel.h"
#import "GetRefuseFooterView.h"
#import "OrderStatusCOMMON226Controller.h"


@interface OrderStatusCOMMON220Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GetRefuseFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusCOMMON220Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    
    [self.view addSubview:self.tableView];
}

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
    [self loadDetailDataFromNet];
}


#pragma mark -- Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (GetRefuseFooterView *)footerView {
    if (!_footerView) {
        self.footerView = [GetRefuseFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.footerView.checkBtuton.backgroundColor = MAIN_THEME_COLOR;
        [self.footerView.checkBtuton setTitle:@"签到确认" forState:UIControlStateNormal];
        self.footerView.refuseButton.backgroundColor = MAIN_THEME_COLOR;
        [self.footerView.refuseButton setTitle:@"退回" forState:UIControlStateNormal];
        [self.footerView.checkBtuton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView.refuseButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommonModel *detailModel = self.dataListArr[indexPath.row];
    
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地名称：%@", detailModel.FRM_SHPG_LOC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地址：%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat appointmentLoadConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预约交货时间：%@", detailModel.APPOINTMENT_END_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPersonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPhoneConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 55.0+loadNumberConstant+loadNameConstant+loadAddressConstant+appointmentLoadConstant+contactPersonConstant+contactPhoneConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *desStr = [OrderStatusManager getOrderDescriptionWithStatus:ORDER_STATUS_220 orderType:ORDER_TYPE_COMMON];
    CGFloat height = [BaseModel heightForTextString:desStr width:(kScreenWidth - 40.0)  fontSize:CELL_LABEL_FONTSIZE];
    return height + 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UILabel *label = [UILabel new];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(header.mas_top).with.offset(10.0);
        make.left.mas_equalTo(header.mas_left).with.offset(20.0);
        make.right.mas_equalTo(header.mas_right).with.offset(-20.0);
    }];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [OrderStatusManager getOrderDescriptionWithStatus:ORDER_STATUS_220 orderType:ORDER_TYPE_COMMON];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonConfirationCell *cell = [CommonConfirationCell getCellWithTable:tableView];
    cell.detailModel = self.dataListArr[indexPath.row];
    return cell;
}

#pragma mark -- ButtonAction

//网络请求数据
- (void)loadDetailDataFromNet {
    [DetailCommonModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
    }];
}

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
//                OrderStatusCOMMON226Controller *checkVC = [OrderStatusCOMMON226Controller new];
//                checkVC.paraDict = self.paraDict;
//                checkVC.orderStatus = [OrderStatusManager getNextProcessWithCurrentStatus:self.orderStatus orderType:self.orderType];
//                [weakself.navigationController pushViewController:checkVC animated:YES];
                
                NSInteger orderStatus = [OrderStatusManager getNextProcessWithCurrentStatus:ORDER_STATUS_220 orderType:ORDER_TYPE_COMMON];
                if (weakself.nextBlock) {
                    weakself.nextBlock(@{@"currentStatus":@(orderStatus)});
                }
            }];
        }
    } failure:^(NSError *error) {
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}

#pragma mark -- 按钮点击操作

//返回按钮点击事件
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//签到确认按钮点击事件
- (void)checkButtonAction:(UIButton *)sender {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    NSString *orderCode = @"";
    NSString *orderCodes = @"";
    for (NSInteger i = 0; i < self.dataListArr.count; i++) {
        DetailCommonModel *model = self.dataListArr[i];
        if (i == 0) {
            orderCode = model.ORDER_CODE;
        }
        orderCodes = [orderCodes stringByAppendingFormat:@",%@", model.SHPM_NUM];
        //首字母是@","的替换为@""
        if (orderCodes.length > 0) {
            NSString *firstStr = [orderCodes substringWithRange:NSMakeRange(0, 1)];
            if ([firstStr isEqualToString:@","]) {
                orderCodes = [orderCodes stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
        }
    }
    NSDictionary *paraDict = @{@"driverTel":driverTel, @"orderCode":orderCode, @"shpmNum":orderCodes, @"type":@"FRM"};
    [self networkWithUrlStr:ORDER_CHECK_API paraDict:paraDict];
}

//退回按钮点击事件
- (void)backButtonAction:(UIButton *)sender {
    [NetworkHelper POST:ORDER_RETURN_API parameters:self.paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
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
