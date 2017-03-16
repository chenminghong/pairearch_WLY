//
//  OrderStatusBACK240Controller.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusBACK240Controller.h"

#import "StartTransportFooterView.h"
#import "BackListDetailCell.h"
#import "BACKNestedSelectController.h"
#import "BackDetailModel.h"

@interface OrderStatusBACK240Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StartTransportFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusBACK240Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setDataListArr:(NSMutableArray *)dataListArr {
    _dataListArr = dataListArr;
    [self.tableView reloadData];
}

- (void)setOrderStatus:(NSInteger)orderStatus {
    _orderStatus = orderStatus;
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:self.orderType];
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
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [StartTransportFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.footerView.startTransportBtn.backgroundColor = THEME_COLOR_BACK;
        [self.footerView.startTransportBtn setTitle:@"出厂确认" forState:UIControlStateNormal];
        [self.footerView.startTransportBtn addTarget:self action:@selector(startTransportAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight - 200 - 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataListArr.count - 1) {
        return 80.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataListArr.count - 1) {
        return self.footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BackListDetailCell *cell = [BackListDetailCell getCellWithTable:tableView];
    cell.detailModel = self.dataListArr[indexPath.row];
    cell.descriptionLabel.text = [OrderStatusManager getOrderDescriptionWithStatus:self.orderStatus orderType:ORDER_TYPE_BACK];
    return cell;
}


#pragma mark -- 按钮响应事件

- (void)startTransportAction:(UIButton *)sender {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    BackDetailModel *model = self.dataListArr[0];
    NSString *orderCode = model.ORDER_CODE? model.ORDER_CODE:@"";
    NSString *orderCodes = model.SHPM_NUM? model.SHPM_NUM:@"";
    NSDictionary *paraDict = @{@"driverTel":driverTel, @"orderCode":orderCode, @"orderCodes":orderCodes};
    [self networkWithUrlStr:ORDER_OUT_GETFAC_API paraDict:paraDict];
}

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
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
