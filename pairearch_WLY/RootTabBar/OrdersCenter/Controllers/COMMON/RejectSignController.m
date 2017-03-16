//
//  RejectSignController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RejectSignController.h"

#import "CommonPickerView.h"

@interface RejectSignController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *selectTf;
@property (weak, nonatomic) IBOutlet UITextView *reasonTV;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) UILabel *placeHoldLabel;  //textView站位标签

@property (nonatomic, strong) UIPickerView *pickView;  //选择框

@end

@implementation RejectSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"收货-场外排队";
    self.reasonTV.layer.borderColor = [UIColor grayColor].CGColor;
    self.reasonTV.layer.borderWidth = 1.0;
    self.selectTf.delegate = self;
    self.selectTf.text = @"异常签收原因";
    
    self.reasonTV.delegate = self;
    [self.reasonTV addSubview:self.placeHoldLabel];
    self.reasonTV.returnKeyType = UIReturnKeyDone;
}

- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        self.placeHoldLabel = [UILabel new];
        [self.reasonTV addSubview:self.placeHoldLabel];
        [self.placeHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reasonTV).with.offset(5);
            make.top.equalTo(self.reasonTV).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        self.placeHoldLabel.font = [UIFont systemFontOfSize:13.0];
        self.placeHoldLabel.textColor = [UIColor grayColor];
        self.placeHoldLabel.text = @"其他原因";
    }
    return _placeHoldLabel;
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSArray *titleList = @[@"原因1", @"原因2", @"原因3"];
    [CommonPickerView showPickerViewInView:self.view titleList:titleList pickBlock:^(NSString *reasonTitle) {
        self.selectTf.text = reasonTitle;
    }];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHoldLabel.hidden = self.reasonTV.hasText;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


//提交按钮事件
- (IBAction)commitButtonAction:(id)sender {
    [NetworkHelper POST:ORDER_REJECT_GET_API parameters:self.paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = responseObject[@"msg"];
        NSInteger resultFlag = [responseObject[@"status"] integerValue];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        if (resultFlag == 1) {
            __weak typeof(self) weakself = self;
            [hud setCompletionBlock:^(){
                [weakself.navigationController popViewControllerAnimated:YES];
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
