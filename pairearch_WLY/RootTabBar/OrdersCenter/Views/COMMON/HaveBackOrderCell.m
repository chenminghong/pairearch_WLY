//
//  HaveBackOrderCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HaveBackOrderCell.h"

#import "CommonBackModel.h"

@implementation HaveBackOrderCell

//初始化
+ (HaveBackOrderCell *)getCellWithTable:(UITableView *)table {
    HaveBackOrderCell *cell = [table dequeueReusableCellWithIdentifier:@"HaveBackOrderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HaveBackOrderCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)setDetailModel:(CommonBackModel *)detailModel {
    _detailModel = detailModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"负载单号：%@", detailModel.ldLegId];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"%@", detailModel.toShpgAddr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.chengLabel.backgroundColor = THEME_COLOR_COMMON;
    self.chengLabel.layer.masksToBounds = YES;
    self.chengLabel.layer.cornerRadius = CGRectGetWidth(self.chengLabel.bounds) / 2.0;
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
