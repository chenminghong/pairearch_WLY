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
    self.getOrderNameLabel.text = [NSString stringWithFormat:@"收货方：%@", detailModel.TO_SHPG_LOC_NAME];
    self.getOrderAddLabel.text = [NSString stringWithFormat:@"收货方地址：%@", detailModel.TO_SHPG_ADDR];
    self.planGetTimeLabel.text = [NSString stringWithFormat:@"预计到货时间：%@", detailModel.APPOINTMENT_END_TIME];
    self.contactNameLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME];
    self.contactNumberLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE];
    
//    self.getOrderNameStraint.constant = [BaseModel heightForTextString:self.getOrderNameLabel.text width:(kScreenWidth - 95.0)  fontSize:self.getOrderNameLabel.font.pointSize];
//    self.getOrderAddressStraint.constant = [BaseModel heightForTextString:self.getOrderAddLabel.text width:(kScreenWidth - 95.0)  fontSize:self.getOrderAddLabel.font.pointSize];
//    self.planGetTimeStraint.constant = [BaseModel heightForTextString:self.planGetTimeLabel.text width:(kScreenWidth - 95.0)  fontSize:self.planGetTimeLabel.font.pointSize];
//    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
