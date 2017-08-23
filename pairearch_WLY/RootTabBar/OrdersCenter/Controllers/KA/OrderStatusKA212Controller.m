//
//  OrderDetailController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusKA212Controller.h"

#import "OrderDetailCell.h"
#import "OrderDetailHeaderView.h"
#import "StartTransportFooterView.h"
#import "OrderDetailModel.h"

@interface OrderStatusKA212Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StartTransportFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusKA212Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setDataListArr:(NSMutableArray *)dataListArr {
    _dataListArr = dataListArr;
    
    [self.tableView reloadData];
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
        [self.tableView registerClass:[OrderDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"OrderDetailHeaderView"];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [StartTransportFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.footerView.startTransportBtn.backgroundColor = MAIN_THEME_COLOR;
        [self.footerView.startTransportBtn setTitle:@"确认接单" forState:UIControlStateNormal];
        [self.footerView.startTransportBtn addTarget:self action:@selector(startTransportAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataListArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel *detailModel = [self.dataListArr[indexPath.section] objectAtIndex:indexPath.row];
    
    CGFloat getOrderNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地：%@", detailModel.TO_SHPG_LOC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat getOrderAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地址：%@", detailModel.TO_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat planGetTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预计送达日期：%@ %@-%@", detailModel.FRM_PKUP_DTT, detailModel.FRM_DPND_CMTD_STRT_DTT, detailModel.FRM_DPND_CMTD_END_DTT] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 21.0+CELL_LABEL_HEIGHT*3+getOrderNameConstant+getOrderAddressConstant+planGetTimeConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    OrderDetailModel *detailModel = [self.dataListArr[section] objectAtIndex:0];
    
    CGFloat fromLocalNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地名称：%@", detailModel.FRM_SHPG_LOC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat fromLocAddConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地址：%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];;
    CGFloat reserveUpTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预约装货时间：%@", detailModel.APPOINTMENT_START_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 26.0+CELL_LABEL_HEIGHT*3+fromLocalNameConstant+fromLocAddConstant+reserveUpTimeConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataListArr.count - 1) {
        return 80.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderDetailHeaderView *header = [OrderDetailHeaderView getHeaderWithTable:tableView];
    NSInteger minStatus = 1000;
    OrderDetailModel *model = nil;
    for (OrderDetailModel *tempModel in self.dataListArr[section]) {
        if (tempModel.SHPM_STATUS.integerValue < minStatus) {
            model = tempModel;
            minStatus = tempModel.SHPM_STATUS.integerValue;
        }
    }
    if (model) {
        header.detailModel = model;
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataListArr.count - 1) {
        return self.footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailCell *cell = [OrderDetailCell getCellWithTable:tableView];
    cell.detailModel = [self.dataListArr[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -- ButtonAction

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                if (weakself.dataListArr.count == 1) {
                    if (weakself.nextBlock) {
                        weakself.nextBlock(@{@"currentStatus":@(ORDER_STATUS_212)});
                    }
                } else {
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            [[LocationUploadManager shareManager] startServiceWithEntityName:[NSString stringWithFormat:@"%@_%@", [LoginModel shareLoginModel].name, [LoginModel shareLoginModel].tel]];
        }
    } failure:^(NSError *error) {
        //添加请求失败视图
        __weak typeof(self) weakself = self;
        [NetFailView showFailViewInView:self.view repeatBlock:^{
            if (weakself.nextBlock) {
                weakself.nextBlock(@{@"currentStatus":@(ORDER_STATUS_212)});
            }
        }];

        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}

#pragma mark -- 按钮点击操作

//开始运输按钮点击事件
- (void)startTransportAction:(UIButton *)sender {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    NSString *orderCode = @"";
    NSString *orderCodes = @"";
    for (NSInteger i = 0; i < self.dataListArr.count; i++) {
        NSArray *modelArr = self.dataListArr[i];
        OrderDetailModel *model = modelArr[0];
        if (model.STATUS && model.STATUS.integerValue != ORDER_STATUS_212) {
            [ProgressHUD bwm_showTitle:@"当前状态不能接单" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            return;
        }
        if (i == 0) {
            orderCode = [orderCode stringByAppendingFormat:@"%@", model.ORDER_CODE];
        } else {
            orderCode = [orderCode stringByAppendingFormat:@",%@", model.ORDER_CODE];
        }
        for (NSInteger j = 0; j < modelArr.count; j++) {
            OrderDetailModel *tempModel = modelArr[j];
            orderCodes = [orderCodes stringByAppendingFormat:@",%@", tempModel.SHPM_NUM];
        }
        //首字母是@","的替换为@""
        if (orderCodes.length > 0) {
            NSString *firstStr = [orderCodes substringWithRange:NSMakeRange(0, 1)];
            if ([firstStr isEqualToString:@","]) {
                orderCodes = [orderCodes stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
        }
    }
    NSDictionary *paraDict = @{@"driverTel":driverTel,
                               @"orderCode":orderCode,
                               @"shpmNum":orderCodes,
                               @"isAgree":@"1"};
    [self networkWithUrlStr:ORDER_GETLOAD_API paraDict:paraDict];
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
