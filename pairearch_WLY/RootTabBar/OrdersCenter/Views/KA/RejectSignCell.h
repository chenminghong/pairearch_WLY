//
//  RejectSignCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/6/1.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RejectSignCell : UITableViewCell<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *selectTf;

@property (weak, nonatomic) IBOutlet UITextView *reasonTV;

@property (nonatomic, strong) UILabel *placeHoldLabel;  //textView站位标签

@property (nonatomic, strong) NSArray *dataListArr;   //数据源

@property (nonatomic, strong) id selectModel;   //选中的数据模型

//初始化
+ (RejectSignCell *)getCellWithTable:(UITableView *)table;

@end
