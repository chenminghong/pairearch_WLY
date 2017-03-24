//
//  AbnormalReportCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "AbnormalReportCell.h"

@implementation AbnormalReportCell

//初始化
+ (AbnormalReportCell *)getCellWithTable:(UITableView *)table {
    AbnormalReportCell *cell = [table dequeueReusableCellWithIdentifier:@"AbnormalReportCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AbnormalReportCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.loadNumberTv.layer.borderColor = TABLE_SEPARATOR_COLOR.CGColor;
    self.loadNumberTv.layer.borderWidth = 1.0;
    [self.loadNumberTv addSubview:self.placeHoldLabel];
}

- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        self.placeHoldLabel = [UILabel new];
        [self.loadNumberTv addSubview:self.placeHoldLabel];
        [self.placeHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.loadNumberTv).with.offset(5);
            make.top.equalTo(self.loadNumberTv).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(250, 20));
        }];
        self.placeHoldLabel.font = [UIFont systemFontOfSize:13.0];
        self.placeHoldLabel.textColor = [UIColor grayColor];
        self.placeHoldLabel.text = @"请填写原因，最多可以输入70个字！";
    }
    return _placeHoldLabel;
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHoldLabel.hidden = textView.hasText;
    if (textView.text.length > 70) {
        textView.text =  [textView.text substringWithRange:NSMakeRange(0, 70)];
    }
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
