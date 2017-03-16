//
//  AbnormalSignCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/7.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OrderDetailModel;

//异常签收按钮点击事件
typedef void(^AbnormalBlock)(OrderDetailModel *model, UIButton *sender);

@interface AbnormalSignCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deliveryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getOrderNameLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getOrderNameStraint;
@property (weak, nonatomic) IBOutlet UILabel *getOrderAddLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getOrderAddStraint;
@property (weak, nonatomic) IBOutlet UILabel *planGetTimeLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planGetTimeStraint;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIButton *abnormalSignBtn;
@property (nonatomic, copy) AbnormalBlock abnormalBlock;  //异常签收按钮点击事件

@property (nonatomic, strong) OrderDetailModel *detailModel;  //model数据

@property (nonatomic, strong) NSIndexPath *indexPath; 


//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table indexPath:(NSIndexPath *)indexPath abnormalBlock:(AbnormalBlock)block;

@end
