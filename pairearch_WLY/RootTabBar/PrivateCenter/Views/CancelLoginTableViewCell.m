//
//  CancelLoginTableViewCell.m
//  WLY
//
//  Created by Leo on 16/3/17.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "CancelLoginTableViewCell.h"



@implementation CancelLoginTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews
{
    __weak typeof(self) weakSelf = self;
    
    //注销登录的字样
    UILabel *cancelLoginL = [[UILabel alloc] init];
    cancelLoginL.text = @"注销登录";
    cancelLoginL.textAlignment = 1;
    cancelLoginL.textColor = [UIColor grayColor];
    cancelLoginL.font = [UIFont boldSystemFontOfSize:20.0];
    [self.contentView addSubview:cancelLoginL];
    [cancelLoginL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(kPersonalCenterFontWidth);
        make.height.mas_equalTo(30);
    }];
}
@end
