//
//  SaftyCheckCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SafetyCheckModel;

@interface SaftyCheckCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *statementLabel;

@property (nonatomic, strong) SafetyCheckModel *model;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
