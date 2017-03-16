//
//  CommonNomalSignCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

typedef void(^ButtonActionBlock)(NSInteger index, DetailCommonModel *model);

@interface CommonNomalSignCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *signAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *nomalSignButton;
@property (weak, nonatomic) IBOutlet UIButton *abbormalSignButton;

@property (nonatomic, strong) DetailCommonModel *detailModel;  //数据源

@property (nonatomic, copy) ButtonActionBlock buttonBlock;  //点击事件回调

//初始化
+ (CommonNomalSignCell *)getCellWithTable:(UITableView *)table buttonBlock:(ButtonActionBlock)buttonBlock;

@end
