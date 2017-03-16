//
//  CancelLoginCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelLoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
