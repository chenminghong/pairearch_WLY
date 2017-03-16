//
//  ListTableCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ListTableCell.h"

#import "OrderListModel.h"

@implementation ListTableCell

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table fightSingleBlock:(FightSingleBlock)fightSingleBlock {
    ListTableCell *cell = [table dequeueReusableCellWithIdentifier:@"ListTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableCell" owner:self options:nil] firstObject];
    }
    cell.fightSingleBlock = fightSingleBlock;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.assortLabel.backgroundColor = MAIN_THEME_COLOR;
    self.kaLabel.backgroundColor = MAIN_THEME_COLOR;
    self.stateLabel.backgroundColor = MAIN_THEME_COLOR;
    
    
    self.separateViewOne.backgroundColor = TABLE_SEPARATOR_COLOR;
    self.separateViewTwo.backgroundColor = TABLE_SEPARATOR_COLOR;
    
    self.assortLabel.layer.masksToBounds = YES;
    self.assortLabel.layer.cornerRadius = CGRectGetWidth(self.assortLabel.bounds) / 2.0;
    
    self.telephoneBtn.hidden = YES;
}

- (void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
    
    if (![orderModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_BACK]) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"xuanzekuang"] forState:UIControlStateSelected];
        [self.selectedBtn setImage:[UIImage imageNamed:@"kongkuang"] forState:UIControlStateNormal];
    } else {
        [self.selectedBtn setImage:[UIImage imageNamed:@"xuanzekuang-back"] forState:UIControlStateSelected];
        [self.selectedBtn setImage:[UIImage imageNamed:@"kongkuang-back"] forState:UIControlStateNormal];
    }
    
    self.selectedBtn.userInteractionEnabled = NO;
    
    //设置选中Button的选中状态
    self.selectedBtn.selected = orderModel.isSelected;
    
    self.loadNameLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    self.loadAddressLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    self.reserveShiptimeLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    self.getNameLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    self.getAddressLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    self.reserveGettimeLabel.preferredMaxLayoutWidth = kScreenWidth - 95.0;
    
    //给view赋值
    self.loadNumberLabel.text = [NSString stringWithFormat:@"负载单号：%@", orderModel.CODE];
    self.loadNameLabel.text = [NSString stringWithFormat:@"发货地名称：%@", orderModel.SOURCE_NAME];
    self.loadAddressLabel.text = [NSString stringWithFormat:@"发货地址：%@", orderModel.SOURCE_ADDR];
    self.reserveShiptimeLabel.text = [NSString stringWithFormat:@"预约发货时间：%@", orderModel.PLAN_DELIVER_TIME];
    self.kaLabel.text = [OrderStatusManager getOrderTypeDesStringWithOrderTyoe:orderModel.TRANSPORT_CODE];
    self.stateLabel.text = [NSString stringWithFormat:@"%@", orderModel.STATUS_NAME];
    self.tonheavierLabel.text = [NSString stringWithFormat:@"货物吨重：%@", orderModel.TOTAL_WEIGHT];
    self.getNameLabel.text = [NSString stringWithFormat:@"收货地名称：%@", orderModel.DC_NAME];
    self.getAddressLabel.text = [NSString stringWithFormat:@"收货地址：%@", orderModel.DC_ADDRESS];
    self.reserveGettimeLabel.text = [NSString stringWithFormat:@"预计到货时间：%@", orderModel.PLAN_ACHIEVE_TIME];
}


//计算文字宽度
- (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
}



#pragma mark -- ButtonAction

//打电话按钮处理事件
- (IBAction)makeTelephoneCallAction:(id)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", @"10000"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//选中按钮处理事件
- (IBAction)selectButtonAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    self.orderModel.isSelected = sender.selected;
//    if (self.fightSingleBlock) {
//        self.fightSingleBlock();
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
