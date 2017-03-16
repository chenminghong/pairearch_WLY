//
//  EvaluationTableCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWStarRateView.h"
@class EvaluationTableModel;

@interface EvaluationTableCell : UITableViewCell <CWStarRateViewDelegate>

@property (strong, nonatomic) UILabel *contentLabel;

@property (nonatomic, strong) CWStarRateView *starView;

@property (nonatomic, strong) UIView *separatorView; //分割线

@property (nonatomic, strong) EvaluationTableModel *model;

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
