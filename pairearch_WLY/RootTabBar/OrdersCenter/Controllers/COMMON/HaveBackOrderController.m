//
//  HaveBackOrderController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HaveBackOrderController.h"

#import "HaveBackOrderCell.h"
#import "GetRefuseFooterView.h"
#import "CommonBackModel.h"

@interface HaveBackOrderController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GetRefuseFooterView *footerView;

@property (nonatomic, strong) CommonBackModel *selectedModel;  //选中的model

@end

@implementation HaveBackOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"有单回空";
    self.view.backgroundColor = [UIColor whiteColor];
    self.orderType = ORDER_TYPE_COMMON;
}

- (void)setParaDict:(NSDictionary *)paraDict {
    _paraDict = paraDict;
    [self loadDetailDataFromNet];
}

- (void)setDataListArr:(NSMutableArray *)dataListArr {
    _dataListArr = dataListArr;
    [self.tableView reloadData];
}

- (void)setSelectedModel:(CommonBackModel *)selectedModel {
    _selectedModel = selectedModel;
    
    if (selectedModel) {
        self.footerView.checkBtuton.backgroundColor = THEME_COLOR_COMMON;
        self.footerView.checkBtuton.userInteractionEnabled = YES;
    } else {
        self.footerView.checkBtuton.backgroundColor = ABNORMAL_THEME_COLOR;
        self.footerView.checkBtuton.userInteractionEnabled = NO;
    }
}

//网络请求数据
- (void)loadDetailDataFromNet {
    [CommonBackModel getDataWithParameters:self.paraDict endBlock:^(id model, NSError *error) {
        NSArray *modelArr = model;
        if (modelArr.count > 0) {
            //对model数据进行分类
            self.dataListArr = [NSMutableArray arrayWithArray:model];
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
                //重新获取数据并且刷新
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
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
        [self.footerView.checkBtuton setTitle:@"确认回空" forState:UIControlStateNormal];
        [self.footerView.refuseButton setTitle:@"取消" forState:UIControlStateNormal];
        self.footerView.checkBtuton.backgroundColor = ABNORMAL_THEME_COLOR;
        self.footerView.refuseButton.backgroundColor = MAIN_THEME_COLOR;
        [self.footerView.checkBtuton addTarget:self action:@selector(sureButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView.refuseButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.footerView.checkBtuton.userInteractionEnabled = NO;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonBackModel *detailModel = self.dataListArr[indexPath.row];
    
    CGFloat loadNumberConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"负载单号：%@", detailModel.ldLegId] width:(kScreenWidth - 100.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"%@", detailModel.toShpgAddr] width:(kScreenWidth - 100.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 21.0+loadNumberConstant+loadAddressConstant;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HaveBackOrderCell *cell = [HaveBackOrderCell getCellWithTable:tableView];
    cell.detailModel = self.dataListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedModel = self.dataListArr[indexPath.row];
}

#pragma mark -- 按钮点击事件

//确定按钮点击事件
- (void)sureButtonAciton:(UIButton *)sender {
    if (self.selectedModel) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"确定对此回空单运输吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSString *oldOrderCode = self.paraDict[@"orderCode"];
            NSString *oldShpmNum = self.paraDict[@"oldShpmNum"];
            NSDictionary *paraDict = @{@"driverTel":[LoginModel shareLoginModel].tel,
                                       @"userName":[LoginModel shareLoginModel].name,
                                       @"oldOrderCode":oldOrderCode,
                                       @"oldShpmNum":oldShpmNum,
                                       @"orderCode":self.selectedModel.ldLegId,
                                       @"nums":self.selectedModel.truckNum,
                                       @"types":self.selectedModel.trucType};
            [NetworkHelper POST:ORDER_SURE_BACK_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *status = responseObject[@"status"];
                NSString *msg = responseObject[@"msg"];
                MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                if ([status integerValue] == 1) {
                    [hud setCompletionBlock:^(){
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            }];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [MBProgressHUD bwm_showTitle:@"请选择需要处理的订单！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }
}

//取消按钮点击事件
- (void)cancelButtonAction:(UIButton *)sender {
    NSString *oldOrderCode = self.paraDict[@"orderCode"];
    NSString *oldShpmNum = self.paraDict[@"oldShpmNum"];
    NSDictionary *paraDict = @{@"driverTel":[LoginModel shareLoginModel].tel, @"userName":[LoginModel shareLoginModel].name, @"oldOrderCode":oldOrderCode, @"oldShpmNum":oldShpmNum};
    [NetworkHelper POST:ORDER_CANCEL_BACK_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *msg = responseObject[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if ([status integerValue] == 1) {
            [hud setCompletionBlock:^(){
                [self.navigationController popViewControllerAnimated:YES];
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
