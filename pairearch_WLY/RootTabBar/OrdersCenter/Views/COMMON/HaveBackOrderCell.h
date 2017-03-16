//
//  HaveBackOrderCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonBackModel;

@interface HaveBackOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) CommonBackModel *detailModel;  //数据源

//初始化
+ (HaveBackOrderCell *)getCellWithTable:(UITableView *)table;

@end
