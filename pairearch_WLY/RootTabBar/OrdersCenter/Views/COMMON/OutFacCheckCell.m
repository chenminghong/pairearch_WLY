//
//  OutFacCheckCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OutFacCheckCell.h"

#import "DetailCommonModel.h"

@implementation OutFacCheckCell

//初始化
+ (OutFacCheckCell *)getCellWithTable:(UITableView *)table buttonBlock:(ButtonActionBlock)buttonBlock {
    OutFacCheckCell *cell = [table dequeueReusableCellWithIdentifier:@"OutFacCheckCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OutFacCheckCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.buttonBlock = buttonBlock;
    return cell;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.signNumberLabel.text = [NSString stringWithFormat:@"交货单号：%@", detailModel.SHPM_NUM];
    self.signAddressLabel.text = [NSString stringWithFormat:@"%@", detailModel.TO_SHPG_ADDR];
    if ([detailModel.isEmpty integerValue] == 0) {
        [self.checkButton setTitle:@"已签收" forState:UIControlStateNormal];
        self.checkButton.userInteractionEnabled = NO;
        self.checkButton.backgroundColor = ABNORMAL_THEME_COLOR;
    } else {
        [self.checkButton setTitle:@"有单回空" forState:UIControlStateNormal];
        self.checkButton.userInteractionEnabled = YES;
        self.checkButton.backgroundColor = THEME_COLOR_BACK;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.checkButton.backgroundColor = THEME_COLOR_BACK;
}
- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonBlock(0, self.detailModel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
