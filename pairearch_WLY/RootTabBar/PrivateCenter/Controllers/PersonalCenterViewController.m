//
//  PersonalCenterViewController.m
//  WLY
//
//  Created by Leo on 16/3/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "PersonalCenterViewController.h"

#import "AlterPasswordViewController.h"
#import "VersionInfoViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AbnormalReportController.h"

#import "PersonalCenterCell.h"
#import "CancelLoginCell.h"

@interface PersonalCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titltArr; //存储title

@property (nonatomic, strong) NSArray *imageNameArr; //存储图片的名字

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    //个人中心界面的背景图片
    self.view.backgroundColor = UIColorFromRGB(0xCBC9C7);
    
    self.title = @"个人中心";
    
    self.titltArr = @[@"异常上报", @"修改密码", @"版本信息", @"关于我们"];
    self.imageNameArr = @[@"yichang", @"shezhimima", @"banbenxinxi", @"guayuwomen"];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置分隔线颜色
    [self.tableView setSeparatorColor:TABLE_SEPARATOR_COLOR];
    //设置分隔线样式
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20.0, 0, 0);
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.titltArr.count;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        PersonalCenterCell *cell = [PersonalCenterCell getCellWithTable:tableView];
        cell.mainLabel.text = self.titltArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.imageNameArr[indexPath.row]];
        return cell;
    } else {
        CancelLoginCell *cell = [CancelLoginCell getCellWithTable:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.00000001;
    }
    return 10;
}

//点击cell触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (indexPath.row == 0) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AbnormalReportController" bundle:[NSBundle mainBundle]];
            AbnormalReportController *abnormalRVC = [sb instantiateViewControllerWithIdentifier:@"AbnormalReportController"];
            [self.navigationController pushViewController:abnormalRVC animated:YES];
        } else if (indexPath.row == 1) {
            AlterPasswordViewController *alterPasswordVC = [[AlterPasswordViewController alloc] init];
            alterPasswordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:alterPasswordVC animated:YES];
        } else if (indexPath.row == 2) {
            VersionInfoViewController *versionInfoVC = [[VersionInfoViewController alloc] init];
            versionInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:versionInfoVC animated:YES];
        } else {
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    } else {
        [LoginViewController showSelfInController:self completeBlock:nil];
    }
}

//移除观察者
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
