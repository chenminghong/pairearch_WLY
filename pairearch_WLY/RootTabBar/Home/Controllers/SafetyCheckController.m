//
//  SafetyCheckController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SafetyCheckController.h"

#import "SaftyCheckCell.h"
#import "SafetyCheckModel.h"

@interface SafetyCheckController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; //选项列表

@property (nonatomic, strong) UIView *footerView; //表尾

@property (nonatomic, strong) NSMutableArray *modelArr; //数据源;

@end

@implementation SafetyCheckController

#pragma mark -- Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.tableFooterView = self.footerView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.backgroundColor = UIColorFromRGB(0xFF5722);
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [self.footerView addSubview:commitBtn];
        [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(30);
            make.right.with.offset(-30);
            make.height.mas_equalTo(35);
            make.centerY.mas_equalTo(self.footerView);
        }];
        [commitBtn addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xCBC9C7);
    
    self.title = @"安全条款确认";
    [self.view addSubview:self.tableView];
    
    self.modelArr = [NSMutableArray arrayWithArray:[SafetyCheckModel getModelArray]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 18, 18);
    [backBtn setImage:[UIImage imageNamed:@"fanhui_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark -- Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaftyCheckCell *cell = [SaftyCheckCell getCellWithTable:tableView];
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SafetyCheckModel *model = self.modelArr[indexPath.row];
    model.selected = @(![model.selected boolValue]);
    SaftyCheckCell *cell = (SaftyCheckCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.model = model;
}

#pragma mark -- UIButtonAction

//返回按钮
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//提交按钮响应事件
- (void)commitButtonAction:(UIButton *)sender {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:[LoginModel shareLoginModel].tel forKey:@"driverTel"];
    for (NSInteger i = 0; i < self.modelArr.count; i++) {
        SafetyCheckModel *model = self.modelArr[i];
        NSString *key = [NSString stringWithFormat:@"isChecked1%ld", (long)i];
        [paraDict setObject:[model.selected boolValue]? @"true":@"false" forKey:key];
    }
    
    [NetworkHelper POST:SAFETY_CONFIRMATION_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = responseObject[@"msg"];
        NSInteger status = [responseObject[@"status"] integerValue];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status == 1) {
            [hud setCompletionBlock:^(){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
