//
//  OrderStatusBACK228Controller.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusBACK228Controller.h"

#import "StartTransportFooterView.h"
#import "BackListDetailCell.h"
#import "BACKNestedSelectController.h"
#import "BackDetailModel.h"

@interface OrderStatusBACK228Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StartTransportFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusBACK228Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setDataListArr:(NSMutableArray *)dataListArr {
    _dataListArr = dataListArr;
//    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleText = [OrderStatusManager getOrderDescriptionWithStatus:ORDER_STATUS_228 orderType:ORDER_TYPE_BACK];
    CGFloat titleConstant = 0.0;
    if (indexPath.row == 0) {
        titleConstant = [BaseModel heightForTextString:titleText width:(kScreenWidth - 40.0)  fontSize:CELL_LABEL_FONTSIZE];
    }
    
    BackDetailModel *detailModel = self.dataListArr[indexPath.row];
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"装货地址:%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];;
    CGFloat toAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地址:%@", detailModel.TO_SHPG_ADDR] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 30.0 + titleConstant + loadNumberConstant + loadAddressConstant + toAddressConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BackListDetailCell *cell = [BackListDetailCell getCellWithTable:tableView];
    cell.detailModel = self.dataListArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.descriptionLabel.text = [OrderStatusManager getOrderDescriptionWithStatus:ORDER_STATUS_228 orderType:ORDER_TYPE_BACK];
    } else {
        cell.descriptionLabel.text = @"";
    }
    return cell;
}


#pragma mark -- 按钮响应事件

- (void)startTransportAction:(UIButton *)sender {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    BackDetailModel *model = self.dataListArr[0];
    NSString *orderCode = model.ORDER_CODE? model.ORDER_CODE:@"";
    NSString *orderCodes = model.SHPM_NUM? model.SHPM_NUM:@"";
    NSDictionary *paraDict = @{@"driverTel":driverTel, @"orderCode":orderCode, @"orderCodes":orderCodes};
    [self networkWithUrlStr:ORDER_OUT_FAC_API paraDict:paraDict];
}

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                if (weakself.nextBlock) {
                    weakself.nextBlock(nil);
                }
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
