//
//  BackListDetailCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackDetailModel;

@interface BackListDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *assortLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;

@property (nonatomic, strong) BackDetailModel *detailModel;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
