//
//  LatestNoticeInfoViewController.m
//  WLY
//
//  Created by Leo on 16/3/21.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LatestNoticeInfoViewController.h"

#import "AutoHeight.h"

@interface LatestNoticeInfoViewController ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;

@end

@implementation LatestNoticeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"最新公告";
    
    //标题
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, self.view.frame.size.width - 60, 20)];
    self.titleL.textColor = [UIColor grayColor];
    self.titleL.font = [UIFont systemFontOfSize:20];
    self.titleL.numberOfLines = 0;
    self.titleL.text = self.latestNoticeTitle;
    [self.view addSubview:self.titleL];
    
    //标题自适应高度
    CGFloat title_height = [AutoHeight heightForContent:self.latestNoticeTitle Width:self.titleL.frame.size.width Font:[UIFont systemFontOfSize:20.0]];
    CGRect title_frame = self.titleL.frame;
    title_frame.size.height = title_height;
    self.titleL.frame = title_frame;
    
    //内容
    self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleL.frame.origin.y + self.titleL.frame.size.height + 20, self.view.frame.size.width - 20, 20)];
    self.contentL.textColor = [UIColor lightGrayColor];
    self.contentL.numberOfLines = 0;
    self.contentL.text = self.latestNoticeContent;
    [self.view addSubview:self.contentL];
    
    //内容自适应高度
    CGFloat content_height = [AutoHeight heightForContent:self.latestNoticeContent Width:self.contentL.frame.size.width Font:[UIFont systemFontOfSize:17]];
    CGRect content_frame = self.contentL.frame;
    content_frame.size.height = content_height;
    self.contentL.frame = content_frame;
}
//返回
- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//将要出现时显示navigationBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
