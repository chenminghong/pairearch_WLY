//
//  EarlyWarningTableCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/6/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EarlyWarningListModel;

@interface EarlyWarningTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *yuanImageView;

@property (weak, nonatomic) IBOutlet UILabel *stateNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *stayTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statementLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) EarlyWarningListModel *model;

/**
 初始化tableCell

 @param tableView 当前的table
 @return 返回cell对象
 */
+ (instancetype)getCellWithTableView:(UITableView *)tableView;

@end
