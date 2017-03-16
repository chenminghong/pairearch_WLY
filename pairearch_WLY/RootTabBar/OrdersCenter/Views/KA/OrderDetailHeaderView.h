//
//  OrderDetailHeaderView.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;

@interface OrderDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLocNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLocAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveUpTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *telephoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *kaLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) OrderDetailModel *detailModel;   //表头数据

//加载cell
+ (instancetype)getHeaderWithTable:(UITableView *)table;

@end
