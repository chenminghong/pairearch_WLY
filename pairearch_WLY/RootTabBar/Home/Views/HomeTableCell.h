//
//  HomeTableCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageModel;

@interface HomeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *assortLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationTimeLabel;

@property (nonatomic, strong) HomePageModel *homeModel;  //主页数据

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
