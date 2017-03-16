//
//  PersonalCenterCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
