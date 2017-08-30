//
//  CommonHeaderCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/8/30.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonHeaderCell.h"

#import "DetailCommonModel.h"

@implementation CommonHeaderCell

+ (CommonHeaderCell *)getCellWithTable:(UITableView *)table {
    CommonHeaderCell *header = [table dequeueReusableCellWithIdentifier:@"CommonHeaderCell"];
    if (!header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"CommonHeaderCell" owner:self options:nil] firstObject];
    }
    header.selectionStyle = UITableViewCellSelectionStyleNone;
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.chengLabel.layer.masksToBounds = YES;
    self.chengLabel.layer.cornerRadius = CGRectGetWidth(self.chengLabel.bounds) / 2.0;
    self.chengLabel.backgroundColor = MAIN_THEME_COLOR;
    self.statusLabel.backgroundColor = MAIN_THEME_COLOR;
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.separatorViewHeight.constant = 1.0;
    self.statusLabel.hidden = YES;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"负载单号：%@", detailModel.ORDER_CODE];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"发货地址：%@", detailModel.FRM_SHPG_ADDR];
    self.heavierTonLabel.text = [NSString stringWithFormat:@"货物重量：%@kg", detailModel.TOTAL_WEIGHT];
    self.contactNumberLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_MOBILE];
    self.contactPersonLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_NAME];
    self.statusLabel.text = [NSString stringWithFormat:@"%@", detailModel.SHPM_STATUS_NAME];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
