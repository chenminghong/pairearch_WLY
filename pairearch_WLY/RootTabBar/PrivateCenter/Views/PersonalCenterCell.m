//
//  PersonalCenterCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "PersonalCenterCell.h"

@implementation PersonalCenterCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    PersonalCenterCell *cell = [table dequeueReusableCellWithIdentifier:@"PersonalCenterCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
