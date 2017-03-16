//
//  OutFacCheckCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

typedef void(^ButtonActionBlock)(NSInteger index, DetailCommonModel *model);

@interface OutFacCheckCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *signAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic, strong) DetailCommonModel *detailModel;  //数据源

@property (nonatomic, copy) ButtonActionBlock buttonBlock;  //点击事件回调

//初始化
+ (OutFacCheckCell *)getCellWithTable:(UITableView *)table buttonBlock:(ButtonActionBlock)buttonBlock;

@end
