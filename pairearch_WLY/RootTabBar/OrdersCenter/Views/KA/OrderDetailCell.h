//
//  OrderDetailCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;

@interface OrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deliveryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getOrderNameLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getOrderNameStraint;
@property (weak, nonatomic) IBOutlet UILabel *getOrderAddLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getOrderAddressStraint;
@property (weak, nonatomic) IBOutlet UILabel *planGetTimeLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planGetTimeStraint;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (nonatomic, strong) OrderDetailModel *detailModel;   //要显示的数据源

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
