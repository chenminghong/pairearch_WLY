//
//  RejectSignCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/1.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RejectSignCell.h"

#import "BidPickerView.h"

@implementation RejectSignCell

//初始化
+ (RejectSignCell *)getCellWithTable:(UITableView *)table {
    RejectSignCell *cell = [table dequeueReusableCellWithIdentifier:@"RejectSignCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RejectSignCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.reasonTV.layer.borderColor = [UIColor grayColor].CGColor;
    self.reasonTV.layer.borderWidth = 1.0;
    self.selectButton.layer.borderColor= [UIColor blackColor].CGColor;
    self.selectButton.layer.borderWidth = 1;
    
    self.reasonTV.delegate = self;
    [self.reasonTV addSubview:self.placeHoldLabel];
    self.reasonTV.returnKeyType = UIReturnKeyDone;
    self.selectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        self.placeHoldLabel = [UILabel new];
        [self.reasonTV addSubview:self.placeHoldLabel];
        [self.placeHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reasonTV).with.offset(5);
            make.top.equalTo(self.reasonTV).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        self.placeHoldLabel.font = [UIFont systemFontOfSize:CELL_LABEL_FONTSIZE];
        self.placeHoldLabel.textColor = [UIColor grayColor];
        self.placeHoldLabel.text = @"其他原因";
    }
    return _placeHoldLabel;
}

- (void)setDataListArr:(NSArray *)dataListArr {
    _dataListArr = dataListArr;
    if (dataListArr.count > 0) {
        self.selectModel = dataListArr[0];
        [self.selectButton setTitle:[dataListArr[0] valueForKey:@"name"] forState:UIControlStateNormal];
    }
}

#pragma mark -- UITextFieldDelegate

- (IBAction)selectButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.dataListArr.count <= 0) {
        [ProgressHUD bwm_showTitle:@"暂无可选数据" toView:self hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    [BidPickerView showSelectViewWithTitle:@"请选择原因" dataArr:self.dataListArr selectBlock:^(id model) {
        self.selectModel = model;
        [self.selectButton setTitle:[model valueForKey:@"name"] forState:UIControlStateNormal];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHoldLabel.hidden = self.reasonTV.hasText;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
