//
//  Common212Cell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

@interface Common212Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *signAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *heavierTonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;

@property (nonatomic, strong) DetailCommonModel *detailModel;  //数据源

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
