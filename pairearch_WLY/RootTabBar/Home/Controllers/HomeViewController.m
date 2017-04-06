//
//  HomeViewController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomeViewController.h"

#import "LoginViewController.h"
#import "PaomaLabel.h"
#import "LatestNoticeInfoViewController.h"
#import "WQLPaoMaView.h"
#import "HomeTableCell.h"
#import "HomePageModel.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *safetyCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView; //顶部banner
@property (nonatomic, strong) PaomaLabel *noticeContentL;  //通知公告栏
@property (nonatomic, strong) WQLPaoMaView *paoma;  //公告栏；

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) NSMutableArray *dataModelArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataModelArr = [NSMutableArray array];
    
    [self.view addSubview:self.paoma];
    [self.view addSubview:self.tableView];
    
    self.safetyCheckBtn.layer.masksToBounds = YES;
    self.safetyCheckBtn.layer.cornerRadius = 5.0;
    self.safetyCheckBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.safetyCheckBtn.layer.borderWidth = 0.5;
    
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = (kScreenWidth * 6) / 32 / 2.0;
    
    
    self.userNameLabel.textColor = UIColorFromRGB(0x666666);
    self.userNumberLabel.textColor = UIColorFromRGB(0x666666);
    
    self.bannerView.backgroundColor = TOP_BOTTOMBAR_COLOR;
    
    //从后台到前台开始动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotificationAction) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //请求首页数据
    [self getHomePageData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.userNameLabel.text = [LoginModel shareLoginModel].name;
    self.userNumberLabel.text = [LoginModel shareLoginModel].tel;
    
    [self.paoma startAnimation];
    
    //获取数据检查状态
    [self getIsSafetyCheck];
    
    //获取首页Data数据
    [self getHomePageData];
    
}

//程序活跃的时候调用
- (void)applicationDidBecomeActiveNotificationAction {
    [self paomaViewStartAnimation];
}

//开始跑马灯
- (void)paomaViewStartAnimation {
    if (self.tabBarController.selectedIndex == 0) {
        [self.paoma startAnimation];
    }
}

#pragma mark -- LazyLoading

- (WQLPaoMaView *)paoma {
    if (!_paoma) {
        self.paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.frame.size.width, 40) withTitle:@"Copyright©2017 上海双至供应链管理有限公司"];
        [self.view addSubview:self.paoma];
        [self.paoma mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
        self.paoma.backgroundColor = MAIN_THEME_COLOR;
    }
    return _paoma;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [UITableView new];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paoma.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom);
            make.right.equalTo(self.view.mas_right);
        }];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UITableView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableHeaderView = self.headLabel;
    }
    return _tableView;
}

- (UILabel *)headLabel {
    if (!_headLabel) {
        self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60.0)];
        self.headLabel.textAlignment = NSTextAlignmentCenter;
        self.headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.headLabel.textColor = MAIN_THEME_COLOR;
        self.headLabel.text = @"装货在途";
    }
    return _headLabel;
}

#pragma mark -- Get Data

//检查是否进行安全检查
- (void)getIsSafetyCheck {
    [[NetworkHelper shareClient] GET:DAFETY_CHECK_API parameters:@{@"driverTel":[LoginModel shareLoginModel].tel? [LoginModel shareLoginModel].tel:@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respondDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger status = [respondDict[@"status"] integerValue];
        if (status == 1) {
            [self.safetyCheckBtn setTitle:@"安全检查" forState:UIControlStateNormal];
        } else {
            [self.safetyCheckBtn setTitle:@"安全检查！" forState:UIControlStateNormal];
        }
        //如果有感叹号，设置感叹号的颜色
        if (self.safetyCheckBtn.currentTitle.length > 4) {
            [self fuwenbenLabel:self.safetyCheckBtn.titleLabel FontNumber:self.safetyCheckBtn.titleLabel.font AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
        }
    } failure:nil];
}

//获取首页Data数据
- (void)getHomePageData {
    [HomePageModel getDataWithParameters:@{@"driverTel":[LoginModel shareLoginModel].tel? [LoginModel shareLoginModel].tel:@""} endBlock:^(id model, NSError *error) {
        NSArray *modelArr = model;
        if (modelArr.count) {
            self.dataModelArr = [NSMutableArray arrayWithArray:model];
        }
        [self.tableView reloadData];
        if (self.dataModelArr.count) {
            HomePageModel *model = self.dataModelArr[0];
            if ([model.type isEqualToString:@"unabsorbed"]) {
                self.headLabel.text = @"新单提示";
            } else if ([model.type isEqualToString:@"distribution"]) {
                self.headLabel.text = @"装货在途";
            } else {
                self.headLabel.text = @"";
            }
        } else {
            self.headLabel.text = @"";
        }
    }];
}

//设置不同字体颜色
- (void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

#pragma mark -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageModel *model = self.dataModelArr[indexPath.row];
    CGFloat loadNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"负载单号：%@", model.CODE] width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat toAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地址：%@", model.DC_ADDRESS] width:(kScreenWidth - 85.0)  fontSize:16.0];
    CGFloat planTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预约装货时间：%@", model.PLAN_DELIVER_TIME] width:(kScreenWidth - 85.0)  fontSize:13.0];
    CGFloat height = loadNameConstant + toAddressConstant + planTimeConstant + 45.0;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableCell *cell = [HomeTableCell getCellWithTable:tableView];
    cell.homeModel = self.dataModelArr[indexPath.row];
    return cell;
}

#pragma mark -- ButtonAction

- (IBAction)telePhoneAction:(UIButton *)sender {
    NSString *str=[NSString stringWithFormat:@"telprompt://%@", @"021-66188125"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)dealloc {
    //移除观察者
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
