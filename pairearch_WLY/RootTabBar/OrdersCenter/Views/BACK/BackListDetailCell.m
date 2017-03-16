//
//  BackListDetailCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BackListDetailCell.h"

#import "BackDetailModel.h"

@implementation BackListDetailCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    BackListDetailCell *cell = [table dequeueReusableCellWithIdentifier:@"BackListDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BackListDetailCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.assortLabel.layer.masksToBounds = YES;
    self.assortLabel.layer.cornerRadius = CGRectGetWidth(self.assortLabel.bounds) / 2.0;
    self.assortLabel.backgroundColor = THEME_COLOR_BACK;
}

- (void)setDetailModel:(BackDetailModel *)detailModel {
    _detailModel = detailModel;
    self.loadNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.loadAddressLabel.text = detailModel.TO_SHPG_ADDR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
