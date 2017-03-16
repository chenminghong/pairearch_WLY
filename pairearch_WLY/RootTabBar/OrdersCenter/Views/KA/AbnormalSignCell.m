//
//  AbnormalSignCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/7.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "AbnormalSignCell.h"

#import "OrderDetailModel.h"

@implementation AbnormalSignCell

+ (instancetype)getCellWithTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath abnormalBlock:(AbnormalBlock)block {
    AbnormalSignCell *cell = [table dequeueReusableCellWithIdentifier:@"AbnormalSignCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AbnormalSignCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.abnormalSignBtn addTarget:cell action:@selector(abnomalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.abnormalBlock = block;
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
    if ([detailModel.SHPM_STATUS integerValue] == ORDER_STATUS_241) {
        [self.abnormalSignBtn setBackgroundColor:ABNORMAL_THEME_COLOR];
        self.abnormalSignBtn.userInteractionEnabled = NO;
    } else {
        [self.abnormalSignBtn setBackgroundColor:MAIN_THEME_COLOR];
        self.abnormalSignBtn.userInteractionEnabled = YES;
    }
}

//异常签收按钮点击事件
- (void)abnomalButtonAction:(UIButton *)sender {
    if ([self.detailModel.selected boolValue]) {
        if (self.abnormalBlock) {
            self.abnormalBlock(self.detailModel, sender);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.abnormalSignBtn.backgroundColor = MAIN_THEME_COLOR;
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
