//
//  OrderStatusCOMMON230Controller.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusCOMMON230Controller.h"

#import "OutFacCheckCell.h"
#import "CommonIntoFacCheckCell.h"
#import "CommonNomalSignCell.h"
#import "DetailCommonModel.h"
#import "RejectSignController.h"
#import "HaveBackOrderController.h"

@interface OrderStatusCOMMON230Controller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) DetailCommonModel *currentModel;

@end

@implementation OrderStatusCOMMON230Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.orderType = ORDER_TYPE_COMMON;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDetailDataFromNet];
}

- (void)setOrderStatus:(NSInteger)orderStatus {
    _orderStatus = orderStatus;
    self.title = [OrderStatusManager getStatusTitleWithOrderStatus:orderStatus orderType:ORDER_TYPE_COMMON];
}

- (void)setDataListArr:(NSMutableArray *)dataListArr {
    _dataListArr = [NSMutableArray arrayWithArray:[self classificationModelWithDetailModelArr:dataListArr]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray *)classificationModelWithDetailModelArr:(NSArray *)detailModelArr {
    DetailCommonModel *tempModel;
    for (DetailCommonModel *detailModel in detailModelArr) {
        if ([detailModel.SHPM_STATUS integerValue] != ORDER_STATUS_230 && [detailModel.SHPM_STATUS integerValue] != ORDER_STATUS_241 && [detailModel.SHPM_STATUS integerValue] != ORDER_STATUS_242) {
            tempModel = detailModel;
            break;
        }
    }
    if (tempModel) {
        for (DetailCommonModel *detailModel in detailModelArr) {
            if (detailModel != tempModel) {
                detailModel.selected = @0;
            }
        }
    }
    return detailModelArr;
}

//获取网络请求参数
- (NSDictionary *)getParaDictFromModelsWithDetailModel:(DetailCommonModel *)detailModel {
    NSString *driverTel = [LoginModel shareLoginModel].tel;
    NSString *orderCode = detailModel.ORDER_CODE;
    NSString *orderCodes = detailModel.SHPM_NUM;
    return @{@"driverTel":driverTel, @"orderCode":orderCode, @"shpmNum":orderCodes};
}

//请求界面数据
- (void)loadDetailDataFromNet {
    [DetailCommonModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}


//按钮请求数据
- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                //重新获取数据并且刷新
                [weakself loadDetailDataFromNet];
            }];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}


//获取heder显示文字描述
- (NSString *)getHeaderTitle {
    NSMutableArray *models = [NSMutableArray array];
    DetailCommonModel *tempModel = nil;
    for (DetailCommonModel *model in self.dataListArr) {
        if ([model.SHPM_STATUS integerValue] > ORDER_STATUS_240) {
            [models addObject:model];
        }
        if ([model.SHPM_NUM integerValue] == ORDER_STATUS_238 || [model.SHPM_NUM integerValue] == ORDER_STATUS_240) {
            tempModel = model;
        }
    }
    if (models.count > 0) {
        NSString *codeStr = @"";
        for (NSInteger i = 0; i < models.count; i++) {
            DetailCommonModel *model = models[i];
            if (i == 0) {
                codeStr = model.SHPM_NUM;
            } else {
                codeStr = [codeStr stringByAppendingFormat:@"，%@", model.SHPM_NUM];
            }
        }
        return [NSString stringWithFormat:@"交货单%@已卸货完成！", codeStr];
    }
    if (!tempModel) {
        tempModel = [self.dataListArr objectAtIndex:0];
    }
    
    return [OrderStatusManager getOrderDescriptionWithStatus:[tempModel.SHPM_STATUS integerValue] orderType:ORDER_TYPE_COMMON];
    
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


#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommonModel *detailModel = self.dataListArr[indexPath.row];
    
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM] width:(kScreenWidth - 100.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"%@", detailModel.FRM_SHPG_ADDR] width:(kScreenWidth - 100.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 70.0+loadNumberConstant+loadAddressConstant;
    if ([detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_241 || [detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_242 || [detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_245) {
        CGFloat labelHeight = [BaseModel heightForTextString:@"已正常签收(或者异常签收)" width:((kScreenWidth - 100.0)) fontSize:CELL_LABEL_FONTSIZE];
        height += (labelHeight + 10.0);
    }
    NSLog(@"%ld, %f", (long)[detailModel.SHPM_STATUS integerValue], height);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *desStr = [self getHeaderTitle];
    if (desStr.length == 0) {
        return 0.0;
    }
    CGFloat height = [BaseModel heightForTextString:desStr width:(kScreenWidth - 40.0)  fontSize:CELL_LABEL_FONTSIZE];
    return height + 20.0;
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
    label.text = [self getHeaderTitle];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommonModel *detailModel = self.dataListArr[indexPath.row];
    if ([detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_230) {   //签到确认
        CommonIntoFacCheckCell *cell = [CommonIntoFacCheckCell getCellWithTable:tableView buttonBlock:^(NSInteger index, DetailCommonModel *model) {
            [self checkButtonActionWithDetailModel:detailModel];
        }];
        [cell.checkButton setTitle:@"签到确认" forState:UIControlStateNormal];
        cell.detailModel = detailModel;
        return cell;
    } else if ([detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_238) {  //入厂确认
        CommonIntoFacCheckCell *cell = [CommonIntoFacCheckCell getCellWithTable:tableView buttonBlock:^(NSInteger index, DetailCommonModel *model) {
            [self intoFacCheckButtonActionWithDetailModel:detailModel];
        }];
        [cell.checkButton setTitle:@"入厂确认" forState:UIControlStateNormal];
        cell.detailModel = detailModel;
        return cell;
    } else if ([detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_240) {  //正常签收
        CommonNomalSignCell *cell = [CommonNomalSignCell getCellWithTable:tableView buttonBlock:^(NSInteger index, DetailCommonModel *model) {
            if (index == 0) {
                [self normalSignButtonActionWithDetailModel:detailModel];
            } else {
                [self abnormalSignButtonActionWithDetailModel:detailModel];
            }
        }];
        cell.detailModel = detailModel;
        return cell;
    }
    OutFacCheckCell *cell = [OutFacCheckCell getCellWithTable:tableView buttonBlock:^(NSInteger index, DetailCommonModel *model) {
        [self haveBackOrderButtonActionWithDetailModel:detailModel];
    }];
    cell.detailModel = detailModel;
    return cell;
}

#pragma mark -- Button点击事件

//入厂签到按钮点击事件
- (void)checkButtonActionWithDetailModel:(DetailCommonModel *)detailModel {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:[self getParaDictFromModelsWithDetailModel:detailModel]];
    [paraDict setObject:@"TO" forKey:@"type"];
    [self networkWithUrlStr:ORDER_GETFAC_CHECK_API paraDict:paraDict];
}

//入厂确认按钮点击事件
- (void)intoFacCheckButtonActionWithDetailModel:(DetailCommonModel *)detailModel {
    [self networkWithUrlStr:ORDER_ENTER_GETFAC_API paraDict:[self getParaDictFromModelsWithDetailModel:detailModel]];
}

//正常签收按钮点击事件
- (void)normalSignButtonActionWithDetailModel:(DetailCommonModel *)detailModel {
    [self networkWithUrlStr:ORDER_OUT_GETFAC_API paraDict:[self getParaDictFromModelsWithDetailModel:detailModel]];
}

//异常签收按钮点击事件
- (void)abnormalSignButtonActionWithDetailModel:(DetailCommonModel *)detailModel {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RejectSignController" bundle:[NSBundle mainBundle]];
    RejectSignController *rsVC = [sb instantiateViewControllerWithIdentifier:@"RejectSignController"];
    rsVC.paraDict = @{@"driverTel":[LoginModel shareLoginModel].tel, @"userName":[LoginModel shareLoginModel].name, @"orderCode":detailModel.ORDER_CODE, @"shpmNum":detailModel.SHPM_NUM};
    [self.navigationController pushViewController:rsVC animated:YES];
}

//有单回空按钮点击事件
- (void)haveBackOrderButtonActionWithDetailModel:(DetailCommonModel *)detailModel {
    HaveBackOrderController *backVC = [HaveBackOrderController new];
    backVC.paraDict = @{@"driverTel":[LoginModel shareLoginModel].tel, @"userName":[LoginModel shareLoginModel].name, @"orderCode":detailModel.ORDER_CODE, @"loc":detailModel.TO_SHPG_LOC_CD, @"oldShpmNum":detailModel.SHPM_NUM};
    [self.navigationController pushViewController:backVC animated:YES];
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
