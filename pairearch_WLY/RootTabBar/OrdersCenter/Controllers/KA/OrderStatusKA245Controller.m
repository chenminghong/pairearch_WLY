//
//  EvaluationViewController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderStatusKA245Controller.h"

#import "EvaluationTableCell.h"
#import "EvalutionHeaderView.h"
#import "EvaluationTableModel.h"

@interface OrderStatusKA245Controller () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EvalutionHeaderView *headerView;  //表头

@property (nonatomic, strong) UIView *footerView; //表尾

@property (nonatomic, strong) NSArray *modelsArr; //数据源

@end

@implementation OrderStatusKA245Controller

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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (EvalutionHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[EvalutionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60.0)];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.backgroundColor = MAIN_THEME_COLOR;
        [commitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
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
    
    self.title = @"服务评价";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(popBackAction:)];
    [self.view addSubview:self.tableView];
    
    self.modelsArr = [EvaluationTableModel getModelArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluationTableCell *cell = [EvaluationTableCell getCellWithTable:tableView];
    EvaluationTableModel *model = self.modelsArr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark -- ButtonAction

//返回按钮点击事件
- (void)popBackAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//提交按钮响应事件
- (void)commitButtonAction:(UIButton *)sender {
    NSMutableDictionary *evaluaDict = [NSMutableDictionary dictionaryWithDictionary:self.paraDict];
    for (EvaluationTableModel *model in self.modelsArr) {
        [evaluaDict setObject:model.score forKey:model.key];
    }
    
    [NetworkHelper POST:ORDER_EVALUATION_API parameters:evaluaDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *msg = [NSString stringWithFormat:@"%@！", responseObject[@"msg"]];
        MBProgressHUD *hud= [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (status) {
            [hud setCompletionBlock:^(){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:@"评价提交失败！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
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
