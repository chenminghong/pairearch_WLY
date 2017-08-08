//
//  LoginViewController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/16.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginTextField.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "InputValueCheckUtil.h"
#import "LoginModel.h"



@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;  //LOGO

@property (nonatomic, strong) LoginTextField *userNameTF;  //用户名

@property (nonatomic, strong) LoginTextField *passwordTF;  //密码

@property (nonatomic, strong) UIButton *loginBtn;  //登录按钮

@property (nonatomic, strong) UILabel *bottomLabel; //版权标签

@end

@implementation LoginViewController

#pragma mark -- Lazy Loading

//登录界面的我来运logo
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        self.logoImageView = [UIImageView new];
        self.logoImageView.image = [UIImage imageNamed:@"logonew.png"];
        self.logoImageView.layer.masksToBounds = YES;
        self.logoImageView.layer.cornerRadius = 10;
        [self.view addSubview:self.logoImageView];
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72 * kHeightProportion, 72 * kHeightProportion));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(50 * kHeightProportion);
        }];
    }
    return _logoImageView;
}

- (LoginTextField *)userNameTF {
    if (!_userNameTF) {
        self.userNameTF = [[LoginTextField alloc] initWithFrame:CGRectMake(50, 160 * kHeightProportion, CGRectGetWidth(self.view.bounds) - 100, 40)];
        self.userNameTF.iconName = @"usernumber";
        self.userNameTF.backgroundColor = [UIColor whiteColor];
        self.userNameTF.placeholder = @"手机号";
        self.userNameTF.keyboardType = UIKeyboardTypeNumberPad;
        self.userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userNameTF.borderStyle = UITextBorderStyleBezel;
        self.userNameTF.returnKeyType = UIReturnKeyDone;
        NSString *userNumber = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NUMBER];
        if (userNumber.length) {
            self.userNameTF.text = [NSString stringWithFormat:@"%@", userNumber];
            [self.userNameTF textDidChangeAction:self.userNameTF];
        }
    }
    return _userNameTF;
}

- (LoginTextField *)passwordTF {
    if (!_passwordTF) {
        self.passwordTF = [[LoginTextField alloc] initWithFrame:CGRectMake(self.userNameTF.frame.origin.x, self.userNameTF.frame.origin.y + self.userNameTF.frame.size.height + 29, self.userNameTF.frame.size.width, self.userNameTF.frame.size.height)];
        self.passwordTF.iconName = @"password";
        self.passwordTF.backgroundColor = [UIColor whiteColor];
        self.passwordTF.placeholder = @"密码";
        self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.layer.cornerRadius = self.userNameTF.layer.cornerRadius;
        self.passwordTF.borderStyle = UITextBorderStyleBezel;
        self.passwordTF.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTF;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginBtn setBackgroundColor:MAIN_THEME_COLOR];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginBtn];
        
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTF.mas_bottom).with.offset(45);
            make.left.equalTo(self.userNameTF.mas_left);
            make.right.equalTo(self.userNameTF.mas_right);
            make.height.mas_equalTo(40);
        }];
    }
    return _loginBtn;
}

//底部标签
- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        self.bottomLabel = [UILabel new];
        [self.view addSubview:self.bottomLabel];
        self.bottomLabel.font = [UIFont systemFontOfSize:CELL_LABEL_FONTSIZE];
        self.bottomLabel.textColor = UIColorFromRGB(0x666666);
//        self.bottomLabel.backgroundColor = UIColorFromRGB(0xF1D6D8);
        self.bottomLabel.backgroundColor = TOP_BOTTOMBAR_COLOR;
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(47);
        }];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.text = @"Copyright©2017 上海双至供应链管理有限公司";
    }
    return _bottomLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"欢迎登录我来运";
    
    //登录界面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.userNameTF];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.bottomLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xF2F2F2);
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_THEME_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER];
    if (phoneNumber.length) {
        self.userNameTF.text = phoneNumber;
    }
}

#pragma mark -- Common Methods

//判断是否登录
+ (BOOL)isLogin {
    return [LoginModel isLoginState];
}

//退出登录页面
- (void)hideLoginPage {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *oldUserName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NUMBER];
    BOOL isChangeNumber = [self.userNameTF.text isEqualToString:oldUserName];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGIN_STATE];
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTF.text forKey:USER_NUMBER];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:USER_ACCOUNT];
    if ([[delegate.window.rootViewController class] isSubclassOfClass:[UITabBarController class]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (!isChangeNumber) {
                [delegate mainAppPage];
            }
        }];
    } else {
        [delegate mainAppPage];
    }
}

//模态出登录界面
+ (void)showSelfInController:(UIViewController *)controller completeBlock:(void (^)())completeBlock {
    LoginViewController *loginVC = [LoginViewController new];
    NavigationController *navigationVC = [[NavigationController alloc] initWithRootViewController:loginVC];
    //显示第一个tabBar
    __weak typeof(controller) weakController = controller;
    [controller presentViewController:navigationVC animated:YES completion:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:LOGIN_STATE];
        [defaults removeObjectForKey:USER_ACCOUNT];
        weakController.tabBarController.selectedIndex = 0;
        if (completeBlock) {
            completeBlock();
        }
        //停止定位上传功能
        [[LocationUploadManager shareManager] stopService];
        
        //友盟账号退出登录
        [MobClick profileSignOff];
        
        //取消别名设置
        [JPUSHService setTags:nil aliasInbackground:@""];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.userNameTF isExclusiveTouch]) {
        [self.userNameTF resignFirstResponder];
    }
    
    if (![self.passwordTF isExclusiveTouch]) {
        [self.passwordTF resignFirstResponder];
    }
}

#pragma mark -- UIButtonAction

- (void)loginButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([NetworkHelper getNetworkStatus] == NetworkStatusNone) {
        [MBProgressHUD bwm_showTitle:@"网络连接错误，请检查网络！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }
    
    if (self.userNameTF.text.length == 0 || self.passwordTF.text.length == 0) {
        [MBProgressHUD bwm_showTitle:@"帐号密码不能为空，请重新输入！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    
    //验证手机号是否正确
    if (![InputValueCheckUtil checkPhoneNum:self.userNameTF.text]) {
        [MBProgressHUD bwm_showTitle:@"输入的手机号格式有误！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"登录中..."];
    NSDictionary *paramDict = @{@"driverTel":[NSString stringWithFormat:@"%@", self.userNameTF.text],
                                @"driverPwd":[NSString stringWithFormat:@"%@", [BaseModel md5HexDigest:self.passwordTF.text]],
                                @"deviceRoot":@"0",
                                @"sdkVersion":[[UIDevice currentDevice] systemVersion],
                                @"androidID":@"",
                                @"macAddress":[BaseModel getMacAddress],
                                @"manufacturer":@"Apple",
                                @"model":[BaseModel iphoneType],
                                @"is4G":@"0",
                                @"wifiEnabled":@"0",
                                @"networkOperatorName":@"0",
                                @"imei":@"0",
                                @"imsi":@"0",
                                @"phoneType":@"0",
                                @"simOperatorName":@"0",
                                @"phoneStatus":@"0",
                                @"simCardNo":@"0",
                                };
    
    [LoginModel getDataWithParameters:paramDict endBlock:^(LoginModel *model, NSError *error) {
        [hud hide:YES];
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"登录成功!" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            NSString *name = [NSString stringWithFormat:@"%@_%@", [LoginModel shareLoginModel].name, [LoginModel shareLoginModel].tel];
            
            //开启定位上传功能
            [[LocationUploadManager shareManager] startServiceWithEntityName:name];
            
            //友盟统计账号登录
            [MobClick profileSignInWithPUID:name];
            
            //在后台给JPush设置别名
            [JPUSHService setTags:nil aliasInbackground:[LoginModel shareLoginModel].tel];
            
            [hud setCompletionBlock:^(){
                [self hideLoginPage];
            }];
        } else {
            NSString *message = error.userInfo[ERROR_MSG];
            [MBProgressHUD bwm_showTitle:message toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
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
