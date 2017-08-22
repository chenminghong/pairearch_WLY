//
//  OrderDetailCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailCell.h"

#import "OrderDetailModel.h"

@implementation OrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}


//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    OrderDetailCell *cell = [table dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setDetailModel:(OrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.deliveryCodeLabel.text = [NSString stringWithFormat:@"交货单：%@", detailModel.SHPM_NUM];
    self.getOrderNameLabel.text = [NSString stringWithFormat:@"收货地：%@", detailModel.TO_SHPG_LOC_NAME];
    self.getOrderAddLabel.text = [NSString stringWithFormat:@"收货地址：%@", detailModel.TO_SHPG_ADDR];
    self.planGetTimeLabel.text = [NSString stringWithFormat:@"预计送达日期：%@", detailModel.APPOINTMENT_END_TIME];
    self.contactNameLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME];
    self.contactNumberLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
