//
//  Common212HeaderView.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommonModel;

@interface Common212HeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *heavierTonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) DetailCommonModel *detailModel;

//获取视图		
+ (Common212HeaderView *)getHeaderViewWithTable:(UITableView *)table;

@end
