//
//  CancelLoginCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/23.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CancelLoginCell.h"

@implementation CancelLoginCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    CancelLoginCell *cell = [table dequeueReusableCellWithIdentifier:@"CancelLoginCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CancelLoginCell" owner:self options:nil] firstObject];
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
