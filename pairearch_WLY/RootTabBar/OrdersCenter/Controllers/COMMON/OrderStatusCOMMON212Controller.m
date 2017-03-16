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
    
    [self.view addSubview:self.tableView];
    self.orderType = ORDER_TYPE_KA;
}

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
    [self loadDetailDataFromNet];
}


- (void)setOrderStatus:(NSInteger)orderStatus {
    _orderStatus = orderStatus;
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:ORDER_TYPE_COMMON];
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
        [self.tableView registerClass:[Common212HeaderView class] forHeaderFooterViewReuseIdentifier:@"OrderDetailHeaderView"];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [StartTransportFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.footerView.startTransportBtn.backgroundColor = MAIN_THEME_COLOR;
        [self.footerView.startTransportBtn setTitle:@"开始运输" forState:UIControlStateNormal];
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
    DetailCommonModel *detailModel = self.dataListArr[indexPath.row];
    
    CGFloat heavierTonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"货物吨重：%@", detailModel.BW_WGT] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat signNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat signAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPersonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"%@", detailModel.DRIVER_MOBILE] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 20.0+heavierTonConstant+signNumberConstant+signAddressConstant+contactPersonConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DetailCommonModel *detailModel = self.dataListArr[section];

    CGFloat getTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"提货日期：%@", detailModel.APPOINTMENT_END_TIME] width:(kScreenWidth - 40.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.ORDER_CODE] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];;
    CGFloat heavierTonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"货物吨重：%@", detailModel.BW_WGT] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_MOBILE] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat contactPersonConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_NAME] width:(kScreenWidth - 85.0)  fontSize:CELL_LABEL_FONTSIZE];
    
    CGFloat height = 55.0+getTimeConstant+loadNumberConstant+loadAddressConstant+heavierTonConstant+contactNumberConstant+contactPersonConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Common212HeaderView *header = [Common212HeaderView getHeaderViewWithTable:tableView];
    if (self.dataListArr.count) {
        header.detailModel = self.dataListArr[0];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Common212Cell *cell = [Common212Cell getCellWithTable:tableView];
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
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
    }];
}

- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                OrderStatusCOMMON220Controller *checkVC = [OrderStatusCOMMON220Controller new];
                checkVC.paraDict = self.paraDict;
                checkVC.orderStatus = [OrderStatusManager getNextProcessWithCurrentStatus:self.orderStatus orderType:self.orderType];
                [weakself.navigationController pushViewController:checkVC animated:YES];
            }];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
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
