//
//  OutFactoryController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusKA228Controller.h"

#import "OrderDetailCell.h"
#import "OrderDetailHeaderView.h"
#import "StartTransportFooterView.h"
#import "OrderDetailModel.h"
#import "OrderStatusKA230Controller.h"
#import "NestedSelectStateController.h"

@interface OrderStatusKA228Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StartTransportFooterView *footerView;  //详情界面开始运输按钮

@end

@implementation OrderStatusKA228Controller

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
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:ORDER_TYPE_KA];
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
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [StartTransportFooterView getFooterView];
        self.footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.footerView.startTransportBtn.backgroundColor = MAIN_THEME_COLOR;
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
    return [self.dataListArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel *detailModel = [self.dataListArr[indexPath.section] objectAtIndex:indexPath.row];
    
    CGFloat getOrderNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货方：%@", detailModel.TO_SHPG_LOC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat getOrderAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货方地址：%@", detailModel.TO_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat planGetTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预计到货时间：%@", detailModel.APPOINTMENT_END_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 21.0+CELL_LABEL_HEIGHT*3+getOrderNameConstant+getOrderAddressConstant+planGetTimeConstant;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    OrderDetailModel *detailModel = [self.dataListArr[section] objectAtIndex:0];
    
    CGFloat fromLocalNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货方名称：%@", detailModel.FRM_SHPG_LOC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat fromLocAddConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货方地址：%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];;
    CGFloat reserveUpTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预约装货时间：%@", detailModel.APPOINTMENT_START_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 56.0+CELL_LABEL_HEIGHT*3+fromLocalNameConstant+fromLocAddConstant+reserveUpTimeConstant;
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
    header.detailModel = [self.dataListArr[section] objectAtIndex:0];
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

//网络请求数据
- (void)loadDetailDataFromNet {
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
            
            [self.tableView reloadData];
            
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
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
                NestedSelectStateController *nestedVC = [NestedSelectStateController new];
                nestedVC.paraDict = paraDict;
                nestedVC.orderStatus = status;
                [weakself.navigationController pushViewController:nestedVC animated:YES];
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
        NSArray *modelArr = self.dataListArr[i];
        OrderDetailModel *model = modelArr[0];
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
    NSDictionary *paraDict = @{@"driverTel":driverTel, @"orderCode":orderCode, @"shpmNum":orderCodes};
    [self networkWithUrlStr:ORDER_OUT_FAC_API paraDict:paraDict];
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
