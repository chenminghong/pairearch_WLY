//
//  Common212HeaderView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "Common212HeaderView.h"

#import "DetailCommonModel.h"

@implementation Common212HeaderView

+ (Common212HeaderView *)getHeaderViewWithTable:(UITableView *)table {
    Common212HeaderView *header = [table dequeueReusableHeaderFooterViewWithIdentifier:@"Common212HeaderView"];
    if (!header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"Common212HeaderView" owner:self options:nil] firstObject];
    }
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.chengLabel.layer.masksToBounds = YES;
    self.chengLabel.layer.cornerRadius = CGRectGetWidth(self.chengLabel.bounds) / 2.0;
    self.chengLabel.backgroundColor = MAIN_THEME_COLOR;
    self.statusLabel.backgroundColor = MAIN_THEME_COLOR;
}

- (void)setDetailModel:(DetailCommonModel *)detailModel {
    _detailModel = detailModel;
    
    self.loadNumberLabel.text = [NSString stringWithFormat:@"负载单号：%@", detailModel.ORDER_CODE];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"收货地址：%@", detailModel.TO_SHPG_ADDR];
    self.heavierTonLabel.text = [NSString stringWithFormat:@"货物吨重：%@", detailModel.BW_WGT];
    self.contactNumberLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_MOBILE];
    self.contactPersonLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_NAME];
    self.statusLabel.text = [NSString stringWithFormat:@"%@", detailModel.SHPM_STATUS_NAME];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
