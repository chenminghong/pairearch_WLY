//
//  AboutUsViewController.m
//  WLY
//
//  Created by Leo on 16/3/21.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "AboutUsViewController.h"
#define kAboutWLY @"关于百威-我来运"
#define kAboutWLYContent @"百威-我来运定位于优化运输行业运作，提升资源匹配效率，为货运行业双方提供信息和交易的平台，通过平台对运输各方的认证，保证运输双方的利益。"
#define kAboutShangHaiPaireach @"关于上海双至"
#define kAboutShangHaiPaireachContent @"公司致力于设计、开发、推广创新的智能运输集成平台，以软件即服务的方式（SaaS)、兼顾PC与APP端，向用户提供服务。以“不断超越的科技创新，永不懈怠的服务精神”的企业理念，旨在把运输供应链上的货主、第三方物流公司、运输公司、司机甚至包括最终收货人无缝连接起来，形成一个透明、高效、合作、共赢的在线生态系统，实现双至使命，即：致力于将【供应链】打造成【共赢链】。\n公司目前产品：TTS（运输跟踪系统）、我来运（安卓版APP）；\n运营中的平台：ITIP（智能运输集成平台）。"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关于我们";
    
    __weak typeof(self) weakSelf = self;
    //关于我来运
    UILabel *aboutWLY = [[UILabel alloc] init];
    aboutWLY.text = kAboutWLY;
    [aboutWLY sizeToFit];
    [self.view addSubview:aboutWLY];
    [aboutWLY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20 * kHeightProportion);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
    }];
    
    //关于我来运的内容
    UILabel *aboutWLYContent = [[UILabel alloc] init];
    aboutWLYContent.text = kAboutWLYContent;
    aboutWLYContent.numberOfLines = 0;
    aboutWLYContent.font = [UIFont systemFontOfSize:15];
    [aboutWLYContent sizeToFit];
    [self.view addSubview:aboutWLYContent];
    [aboutWLYContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(aboutWLY.mas_bottom).with.offset(10 * kHeightProportion);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
        
    }];
    
    //关于上海双至
    UILabel *aboutShangHaiPaireach = [[UILabel alloc] init];
    aboutShangHaiPaireach.text = kAboutShangHaiPaireach;
    [aboutShangHaiPaireach sizeToFit];
    [self.view addSubview:aboutShangHaiPaireach];
    [aboutShangHaiPaireach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutWLYContent.mas_bottom).with.offset(30 * kHeightProportion);
        make.left.equalTo(aboutWLYContent);
    }];
    
    //关于上海双至的内容
    UITextView *aboutShangHaiPaireachContent = [[UITextView alloc] init];
    aboutShangHaiPaireachContent.text = kAboutShangHaiPaireachContent;
    [aboutShangHaiPaireachContent sizeToFit];
    aboutShangHaiPaireachContent.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:aboutShangHaiPaireachContent];
    [aboutShangHaiPaireachContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutShangHaiPaireach.mas_bottom).with.offset(10 * kHeightProportion);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-10);
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
