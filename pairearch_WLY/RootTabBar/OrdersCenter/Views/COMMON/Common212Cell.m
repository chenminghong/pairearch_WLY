//
//  Common212Cell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "Common212Cell.h"

#import "DetailCommonModel.h"

@implementation Common212Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

+ (instancetype)getCellWithTable:(UITableView *)table {
    Common212Cell *cell = [table dequeueReusableCellWithIdentifier:@"Common212Cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Common212Cell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.heavierTonLabel.text = [NSString stringWithFormat:@"货物吨重：%@", detailModel.BW_WGT];
    self.signNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.signAddressLabel.text = [NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR];
    self.contactPersonLabel.text = [NSString stringWithFormat:@"%@", detailModel.DRIVER_MOBILE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
