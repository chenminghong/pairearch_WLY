//
//  CommonNomalSignCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonNomalSignCell.h"

#import "DetailCommonModel.h"

@implementation CommonNomalSignCell

//初始化
+ (CommonNomalSignCell *)getCellWithTable:(UITableView *)table buttonBlock:(ButtonActionBlock)buttonBlock {
    CommonNomalSignCell *cell = [table dequeueReusableCellWithIdentifier:@"CommonNomalSignCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonNomalSignCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.buttonBlock = buttonBlock;
    return cell;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.signNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.signAddressLabel.text = [NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.nomalSignButton.backgroundColor = MAIN_THEME_COLOR;
    self.abbormalSignButton.backgroundColor = MAIN_THEME_COLOR;
}
- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonBlock((sender.tag - 100), self.detailModel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
