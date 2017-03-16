//
//  SaftyCheckCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SaftyCheckCell.h"

#import "SafetyCheckModel.h"

@implementation SaftyCheckCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    SaftyCheckCell *cell = [table dequeueReusableCellWithIdentifier:@"SaftyCheckCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SaftyCheckCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SafetyCheckModel *)model {
    _model = model;
    self.statementLabel.text = [NSString stringWithFormat:@"%@", model.safetyStr];
    if ([model.selected boolValue]) {
        self.selectView.image = [UIImage imageNamed:@"xuanzekuang"];
    } else {
        self.selectView.image = [UIImage imageNamed:@"kongkuang"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
