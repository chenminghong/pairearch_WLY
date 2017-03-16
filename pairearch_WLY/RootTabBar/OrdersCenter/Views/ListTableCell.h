//
//  ListTableCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;

typedef void(^FightSingleBlock)();

@interface ListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *assortLabel;              //成
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;          //发货单号
@property (weak, nonatomic) IBOutlet UILabel *loadNameLabel;            //发货地名称
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;         //发货地地址
@property (weak, nonatomic) IBOutlet UILabel *reserveShiptimeLabel;     //预约发货时间
@property (weak, nonatomic) IBOutlet UILabel *kaLabel;                  //KA
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;               //订单状态
@property (weak, nonatomic) IBOutlet UILabel *tonheavierLabel;          //货物吨重
@property (weak, nonatomic) IBOutlet UILabel *getNameLabel;             //收货地名称
@property (weak, nonatomic) IBOutlet UILabel *getAddressLabel;          //收货地地址
@property (weak, nonatomic) IBOutlet UILabel *reserveGettimeLabel;      //预约到达时间
@property (weak, nonatomic) IBOutlet UIButton *telephoneBtn;            //打电话按钮
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;             //选中按钮
@property (weak, nonatomic) IBOutlet UIImageView *separateViewOne;      //中间分割线
@property (weak, nonatomic) IBOutlet UIImageView *separateViewTwo;      //底部分割线

@property (nonatomic, strong) NSIndexPath *indexPath;                   //当前的cell位置;

@property (nonatomic, strong) OrderListModel *orderModel;               //数据模型
@property (nonatomic, copy) FightSingleBlock fightSingleBlock;          //拼单按钮回调

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table fightSingleBlock:(FightSingleBlock)fightSingleBlock;

@end
