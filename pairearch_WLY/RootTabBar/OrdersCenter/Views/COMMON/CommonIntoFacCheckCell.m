//
//  CommonIntoFacCheckCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonIntoFacCheckCell.h"

#import "DetailCommonModel.h"

@implementation CommonIntoFacCheckCell

//初始化
+ (CommonIntoFacCheckCell *)getCellWithTable:(UITableView *)table buttonBlock:(ButtonActionBlock)buttonBlock {
    CommonIntoFacCheckCell *cell = [table dequeueReusableCellWithIdentifier:@"CommonIntoFacCheckCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonIntoFacCheckCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.buttonBlock = buttonBlock;
    return cell;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.signNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.signAddressLabel.text = [NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR];
    
    if ([detailModel.selected boolValue]) {
        self.checkButton.backgroundColor = MAIN_THEME_COLOR;
        self.checkButton.userInteractionEnabled = YES;
    } else {
        self.checkButton.backgroundColor = ABNORMAL_THEME_COLOR;
        self.checkButton.userInteractionEnabled = NO;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.checkButton.backgroundColor = MAIN_THEME_COLOR;
}
- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonBlock(0, self.detailModel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
