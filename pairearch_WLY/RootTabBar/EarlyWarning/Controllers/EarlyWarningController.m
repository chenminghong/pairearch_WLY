//
//  EarlyWarningController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EarlyWarningController.h"

#import "EarlyWarningTableCell.h"
#import "EarlyWarningListModel.h"
#import "RefuseSignController.h"


@interface EarlyWarningController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataListArr;

@end

@implementation EarlyWarningController

#pragma mark -- Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.tableView andAction:@selector(getListDataFromNet)];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"预警";
    self.dataListArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //请求网络上数据
    [MJRefreshUtil begainRefresh:self.tableView];
}



/**
 请求数据
 */
- (void)getListDataFromNet {
    [EarlyWarningListModel getDataWithParameters:@{@"driverTel":[LoginModel shareLoginModel].tel} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.dataListArr = [NSMutableArray arrayWithArray:model];
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:2];
            if (self.dataListArr.count <= 0) {
                [ProgressHUD bwm_showTitle:@"暂无数据" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                item.badgeValue = nil;
            } else {
                item.badgeValue = [NSString stringWithFormat:@"%ld", self.dataListArr.count];
            }
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.tableView reloadData];
        [MJRefreshUtil endRefresh:self.tableView];
    }];
}


/**
 修改角标
 */
- (void)getListDataBackground {
    [[NetworkHelper shareClient] GET:WARNING_LIST_API parameters:@{@"driverTel":[LoginModel shareLoginModel].tel} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:2];
            NSArray *orders = responseObject[@"orders"];
            if (orders.count > 0) {
                item.badgeValue = [NSString stringWithFormat:@"%ld", orders.count];
            } else {
                item.badgeValue = nil;
            }
        }
    } failure:nil];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarlyWarningListModel *model = self.dataListArr[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"在%@停留超过%@分钟", model.regions, model.stopTime];
    CGFloat addressConstant = [BaseModel heightForTextString:text width:(kScreenWidth - 140.0) fontSize:14.0];
    return 40.0 + addressConstant;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarlyWarningTableCell *cell = [EarlyWarningTableCell getCellWithTableView:tableView];
    cell.model = self.dataListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EarlyWarningListModel *model = self.dataListArr[indexPath.row];
    RefuseSignController *refuseVC = [RefuseSignController pushToRefuseSignWithController:self signResultBlock:^(NSDictionary *signResult) {
        
    }];
    refuseVC.paraDict = @{@"id":model.abnormalId};
    refuseVC.lxCode = ABNORMAL_CODE_263;
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
