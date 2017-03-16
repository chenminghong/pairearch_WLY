//
//  BackConfirationCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonConfirationCell.h"

#import "DetailCommonModel.h"

@implementation CommonConfirationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.statusLabel.backgroundColor = MAIN_THEME_COLOR;
    self.chengLabel.backgroundColor = MAIN_THEME_COLOR;
    self.chengLabel.layer.masksToBounds = YES;
    self.chengLabel.layer.cornerRadius = CGRectGetWidth(self.chengLabel.bounds) / 2.0;
}

+ (instancetype)getCellWithTable:(UITableView *)table {
    CommonConfirationCell *cell = [table dequeueReusableCellWithIdentifier:@"CommonConfirationCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BackConfirationCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.loadNameLabel.text = [NSString stringWithFormat:@"发货方名称：%@", detailModel.FRM_SHPG_LOC_NAME];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"发货方地址：%@", detailModel.FRM_SHPG_ADDR];
    self.appointmentLoadLabel.text = [NSString stringWithFormat:@"预约交货时间：%@", detailModel.APPOINTMENT_END_TIME];
    self.contactPersonLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME];
    self.contactPhoneLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE];
    self.statusLabel.text = detailModel.SHPM_STATUS_NAME;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
