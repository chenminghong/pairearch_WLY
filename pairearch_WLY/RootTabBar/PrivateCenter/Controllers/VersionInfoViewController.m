//
//  VersionInfoViewController.m
//  WLY
//
//  Created by Leo on 16/3/21.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "VersionInfoViewController.h"

#define kVersionInfo @"百威-我来运V1.0.1"
#define kCopyrightInfo @"Copyright©2017 上海双至供应链管理有限公司"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"版本信息";
    
    //LOGO
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logonew.png"]];
    [self.view addSubview:logoImageView];
    __weak typeof(self) weakSelf = self;
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(50);
    }];
    
    //版本信息
    UILabel *versionInfoL = [[UILabel alloc] init];
    versionInfoL.textColor = UIColorFromRGB(0x666666);
    versionInfoL.text = [NSString stringWithFormat:@"%@V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    versionInfoL.font = [UIFont systemFontOfSize:18.0];
    versionInfoL.textAlignment = 1;
    [self.view addSubview:versionInfoL];
    [versionInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).with.offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(30);
    }];
    
    //版权信息
    UILabel *copyrightL = [[UILabel alloc] init];
    copyrightL.textAlignment = NSTextAlignmentCenter;
    copyrightL.textColor = [UIColor lightGrayColor];
    copyrightL.font = [UIFont systemFontOfSize:13.0];
    copyrightL.textColor = UIColorFromRGB(0x666666);
    copyrightL.text = kCopyrightInfo;
    [self.view addSubview:copyrightL];
    [copyrightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.left.equalTo(weakSelf.view.mas_left);
        make.height.mas_equalTo(47);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
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
