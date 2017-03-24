//
//  AbnormalReportCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbnormalReportCell : UITableViewCell<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loadNumberTf;
@property (weak, nonatomic) IBOutlet UITextView *loadNumberTv;
@property (nonatomic, strong) UILabel *placeHoldLabel;  //textView站位标签

//初始化
+ (AbnormalReportCell *)getCellWithTable:(UITableView *)table;

@end
