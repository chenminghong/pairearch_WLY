//
//  BackConfirationCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

@interface CommonConfirationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLoadLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (nonatomic, strong) DetailCommonModel *detailModel;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
