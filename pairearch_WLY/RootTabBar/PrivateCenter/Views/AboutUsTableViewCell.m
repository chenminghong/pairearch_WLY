//
//  AboutUsTableViewCell.m
//  WLY
//
//  Created by Leo on 16/3/17.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "AboutUsTableViewCell.h"

@implementation AboutUsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews
{
    __weak typeof(self) weakSelf = self;
    //关于我们cell前面的图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal3.png"]];
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(kPersonalCenterIconSideLength, kPersonalCenterIconSideLength));
        
    }];
    
    //关于我们的字样
    UILabel *setPasswordL = [[UILabel alloc] init];
    setPasswordL.text = @"关于我们";
    setPasswordL.textColor = [UIColor grayColor];
    setPasswordL.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:setPasswordL];
    [setPasswordL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImageView.mas_right).with.offset(10);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(100);
        make.height.equalTo(iconImageView);
        
    }];
    
    //右边的小箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into_icon.png"]];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(kPersonalCenterArrowSideLength, kPersonalCenterArrowSideLength));
    }];
}
@end
