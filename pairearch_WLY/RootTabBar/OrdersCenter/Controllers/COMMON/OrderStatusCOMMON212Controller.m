//
//  OrderStatusCOMMON212Controller.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusCOMMON212Controller.h"

#import "StartTransportFooterView.h"
#import "Common212Cell.h"
#import "Common212HeaderView.h"
#import "DetailCommonModel.h"
#import "OrderStatusCOMMON220Controller.h"
#import "CommonConfirationCell.h"

@interface OrderStatusCOMMON212Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StartTransportFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusCOMMON212Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataListArr.count <= 0) {
        return 0.0;
    }
    DetailCommonModel *detailModel = self.dataListArr[indexPath.row];
    CGFloat labelWidth = kScreenWidth - 85.0;
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地名称：%@", detailModel.TO_SHPG_LOC_NAME] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地址：%@", detailModel.TO_SHPG_ADDR] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat appointmentLoadConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预计送达日期：%@ %@-%@", detailModel.TO_DLVY_DTT, detailModel.FRM_DPND_CMTD_STRT_DTT, detailModel.FRM_DPND_CMTD_END_DTT] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPersonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPhoneConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE] width:labelWidth  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 25.0+loadNumberConstant+loadNameConstant+loadAddressConstant+appointmentLoadConstant+contactPersonConstant+contactPhoneConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataListArr.count <= 0) {
        return 0.0;
    }
    DetailCommonModel *detailModel = self.dataListArr[section];

    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"负载单号：%@", detailModel.ORDER_CODE] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地址：%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];;
    CGFloat heavierTonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"货物重量：%@kg", detailModel.TOTAL_WEIGHT] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_MOBILE] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPersonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_NAME] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    
    CGFloat height = 20.0 + loadNumberConstant + loadAddressConstant + heavierTonConstant +contactNumberConstant + contactPersonConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Common212HeaderView *header = [Common212HeaderView getHeaderViewWithTable:tableView];
    if (self.dataListArr.count) {
        DetailCommonModel *model = self.dataListArr[0];
//        model.TOTAL_WEIGHT = self.paraDict[@"totalWeight"];
        header.detailModel = self.dataListArr[0];
    }
//    header.contentView.backgroundColor = [UIColor redColor];
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

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                NSInteger orderStatus = [OrderStatusManager getNextProcessWithCurrentStatus:ORDER_STATUS_212 orderType:ORDER_TYPE_COMMON];
                if (weakself.nextBlock) {
                    weakself.nextBlock(@{@"currentStatus":@(orderStatus)});
                }
            }];
            [[LocationUploadManager shareManager] startServiceWithEntityName:[NSString stringWithFormat:@"%@_%@", [LoginModel shareLoginModel].name, [LoginModel shareLoginModel].tel]];
        }
    } failure:^(NSError *error) {
        self.dataListArr = [NSMutableArray array];
        //添加请求失败视图
        [NetFailView showFailViewInView:self.view repeatBlock:^{
            if (self.nextBlock) {
                self.nextBlock(@{@"currentStatus":@(ORDER_STATUS_212)});
            }
        }];
        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}

#pragma mark -- 按钮点击操作

//返回按钮点击事件
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//开始运输按钮点击事件
- (void)startTransportAction:(UIButton *)sender {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    NSString *orderCode = @"";
    NSString *orderCodes = @"";
    for (NSInteger i = 0; i < self.dataListArr.count; i++) {
        DetailCommonModel *model = self.dataListArr[i];
        if (model.STATUS && model.STATUS.integerValue != ORDER_STATUS_212) {
            [ProgressHUD bwm_showTitle:@"当前状态不能接单" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            return;
        }
        
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
    NSDictionary *paraDict = @{@"driverTel":driverTel, @"orderCode":orderCode, @"shpmNum":orderCodes};
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
