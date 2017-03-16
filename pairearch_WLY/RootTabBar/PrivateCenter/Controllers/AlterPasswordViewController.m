//
//  AlterPasswordViewController.m
//  WLY
//
//  Created by Leo on 16/3/21.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "AlterPasswordViewController.h"

#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface AlterPasswordViewController ()
@property (nonatomic, strong) UITextField *originalPasswordTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *confirmNewPasswordTF;

@end

@implementation AlterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置密码";
    
    //原密码
    self.originalPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, self.view.frame.size.width - 40, 40)];
    self.originalPasswordTF.placeholder = @"原密码";
    self.originalPasswordTF.secureTextEntry = YES;
    self.originalPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.originalPasswordTF];
    
    //第一条分隔线
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.originalPasswordTF.frame.origin.y + self.originalPasswordTF.frame.size.height + 5, self.view.frame.size.width - 20, 2)];
    firstLine.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [self.view addSubview:firstLine];
    
    //新密码
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(self.originalPasswordTF.frame.origin.x, firstLine.frame.origin.y + firstLine.frame.size.height + 5, self.originalPasswordTF.frame.size.width, self.originalPasswordTF.frame.size.height)];
    self.passwordTF.placeholder = @"新密码";
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.passwordTF];
    
    //第二条分隔线
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(firstLine.frame.origin.x, self.passwordTF.frame.origin.y + self.passwordTF.frame.size.height + 5, firstLine.frame.size.width, firstLine.frame.size.height)];
    secondLine.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [self.view addSubview:secondLine];
    
    //再次输入新密码
    self.confirmNewPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(self.passwordTF.frame.origin.x, secondLine.frame.origin.y + secondLine.frame.size.height + 10, self.passwordTF.frame.size.width, self.passwordTF.frame.size.height)];
    self.confirmNewPasswordTF.placeholder = @"再次输入新密码";
    self.confirmNewPasswordTF.secureTextEntry = YES;
    self.confirmNewPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.confirmNewPasswordTF];
    
    //第三条分隔线
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(secondLine.frame.origin.x, self.confirmNewPasswordTF.frame.origin.y + self.confirmNewPasswordTF.frame.size.height + 5, secondLine.frame.size.width, secondLine.frame.size.height)];
    thirdLine.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [self.view addSubview:thirdLine];
    
    //确定button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_big_nor.png"] forState:UIControlStateNormal];
    [button  setTitle:@"确定" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdLine.mas_bottom).with.offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.frame.size.width / 2, 40));
    }];
}

//确定button
- (void)buttonAction {
    //判断原密码、新密码和确认密码是否为空
    if (0 == self.originalPasswordTF.text.length || 0 == self.passwordTF.text.length || 0 == self.confirmNewPasswordTF.text.length) {
        //提醒用户输入信息不能为空
        [MBProgressHUD bwm_showTitle:@"输入的密码不能为空" toView:self.view hideAfter:2.0];
        return;
    } else {
        //如果原密码与修改后的密码相同，提醒用户
        if ([self.originalPasswordTF.text isEqualToString:self.passwordTF.text]) {
            [MBProgressHUD bwm_showTitle:@"新密码与原密码相同，请重新输入！" toView:self.view hideAfter:2.0];
            self.originalPasswordTF.text = @"";
            self.passwordTF.text = @"";
            self.confirmNewPasswordTF.text = @"";
            return;
        } else {
            //如果修改密码与确认密码不相同，提醒用户
            if (![self.passwordTF.text isEqualToString:self.confirmNewPasswordTF.text]) {
                [MBProgressHUD bwm_showTitle:@"两次密码输入不一致，请重新输入！" toView:self.view hideAfter:2.0];
                self.passwordTF.text = @"";
                self.confirmNewPasswordTF.text = @"";
                return;
            } else {
                //如果原密码输入错误，提醒用户
                NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUNT];
                if (![self.originalPasswordTF.text isEqualToString:password]) {
                    [MBProgressHUD bwm_showTitle:@"原始密码输入错误，请重新输入！" toView:self.view hideAfter:2.0];
                } else {
                    //请求修改密码
                    [self PostRequestForAlterPasswordWithOldPwd:self.originalPasswordTF.text AndPwd:self.passwordTF.text];
                    
                }
            }
        }
    }

}

//请求修改密码
- (void)PostRequestForAlterPasswordWithOldPwd:(NSString *)oldPwd AndPwd:(NSString *)pwd {
    [self.view endEditing:YES];
    NSDictionary *paraDict = @{@"mobile":[[NSUserDefaults standardUserDefaults] objectForKey:USER_NUMBER], @"newPwd":[BaseModel md5HexDigest:self.passwordTF.text]};
    
    MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在修改密码..."];
    [[NetworkHelper shareClient] POST:CHANGE_PASSWORD_API parameters:paraDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"change_PWD:%@", dataDict);
        NSInteger updateResult = [dataDict[@"updateResult"] integerValue];
        if (updateResult != 0) {
            [MBProgressHUD bwm_showTitle:@"密码修改失败，请重试!" toView:self.view hideAfter:2.0];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"密码修改成功!" toView:self.view hideAfter:2.0];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:USER_ACCOUNT];
        [LoginModel updateInfoValue:[BaseModel md5HexDigest:self.passwordTF.text] forKey:@"pwd"];
        __weak typeof(self) weakself = self;
        [hud setCompletionBlock:^(){
            [LoginViewController showSelfInController:weakself completeBlock:^{
                [weakself.navigationController popViewControllerAnimated:NO];
            }];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        NSString *description = error.localizedFailureReason.length == 0? @"修改密码失败!":error.localizedFailureReason;
        [MBProgressHUD bwm_showTitle:description toView:self.view hideAfter:2.0];
        
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
