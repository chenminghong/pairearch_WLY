//
//  HomeTableCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomeTableCell.h"

#import "HomePageModel.h"

@implementation HomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.assortLabel.layer.masksToBounds = YES;
    self.assortLabel.layer.cornerRadius = CGRectGetWidth(self.assortLabel.bounds) / 2.0;
    self.assortLabel.backgroundColor = MAIN_THEME_COLOR;
    self.loadNumberLabel.textColor = MAIN_THEME_COLOR;
    self.loadAddressLabel.textColor = MAIN_THEME_COLOR;
}

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    HomeTableCell *cell = [table dequeueReusableCellWithIdentifier:@"HomeTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setHomeModel:(HomePageModel *)homeModel {
    _homeModel = homeModel;
    if ([homeModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_KA]) {
        self.assortLabel.text = @"KA";
    } else if ([homeModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_BACK]) {
        self.assortLabel.text = @"回";
    } else if ([homeModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_COMMON]) {
        self.assortLabel.text = @"常";
    }
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"负载单号：%@", homeModel.CODE];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"收货地址：%@", homeModel.DC_ADDRESS];
    self.reservationTimeLabel.text = [NSString stringWithFormat:@"预约装货时间：%@", homeModel.PLAN_DELIVER_TIME];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
