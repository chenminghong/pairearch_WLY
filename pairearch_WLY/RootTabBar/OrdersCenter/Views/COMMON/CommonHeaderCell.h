//
//  CommonHeaderCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/8/30.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

@interface CommonHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *heavierTonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorViewHeight;

@property (nonatomic, strong) DetailCommonModel *detailModel;

//获取视图
+ (CommonHeaderCell *)getCellWithTable:(UITableView *)table;

@end
