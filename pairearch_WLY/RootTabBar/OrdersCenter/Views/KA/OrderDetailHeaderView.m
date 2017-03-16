//
//  OrderDetailHeaderView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailHeaderView.h"

#import "OrderDetailModel.h"

@implementation OrderDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.chengLabel.layer.masksToBounds = YES;
    self.chengLabel.layer.cornerRadius = CGRectGetWidth(self.chengLabel.bounds) / 2.0;
    self.chengLabel.backgroundColor = MAIN_THEME_COLOR;
    self.kaLabel.backgroundColor = MAIN_THEME_COLOR;
    self.stateLabel.backgroundColor = MAIN_THEME_COLOR;
}

//加载cell
+ (instancetype)getHeaderWithTable:(UITableView *)table {
    OrderDetailHeaderView *cell = [table dequeueReusableHeaderFooterViewWithIdentifier:@"OrderDetailHeaderView"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailHeaderView" owner:self options:nil] firstObject];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailHeaderView" owner:self options:nil] firstObject];;
    }
    return self;
}

- (void)setDetailModel:(OrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.orderCodeLabel.text = [NSString stringWithFormat:@"负载单号：%@", detailModel.ORDER_CODE];
    self.fromLocNameLabel.text = [NSString stringWithFormat:@"发货方名称：%@", detailModel.FRM_SHPG_LOC_NAME];
    self.fromLocAddLabel.text = [NSString stringWithFormat:@"发货方地址：%@", detailModel.FRM_SHPG_ADDR];
    self.reserveUpTimeLabel.text = [NSString stringWithFormat:@"预约装货时间：%@", detailModel.APPOINTMENT_START_TIME];
    self.contactNameLabel.text = [NSString stringWithFormat:@"联系人：%@", detailModel.DRIVER_NAME];
    self.contactNumberLabel.text = [NSString stringWithFormat:@"电话：%@", detailModel.DRIVER_MOBILE];
    self.kaLabel.text = [OrderStatusManager getOrderTypeDesStringWithOrderTyoe:detailModel.TRANSPORT_CODE];
    self.stateLabel.text = detailModel.SHPM_STATUS_NAME;
    
    self.telephoneBtn.hidden = YES;
}

//计算文字宽度
- (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
}

- (IBAction)telephoneButtonAction:(UIButton *)sender {
    NSLog(@"打电话");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
