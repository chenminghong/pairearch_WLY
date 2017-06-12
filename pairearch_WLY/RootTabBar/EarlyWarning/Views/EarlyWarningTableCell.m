//
//  EarlyWarningTableCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EarlyWarningTableCell.h"

#import "EarlyWarningListModel.h"


@implementation EarlyWarningTableCell

+ (instancetype)getCellWithTableView:(UITableView *)tableView {
    EarlyWarningTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarlyWarningTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EarlyWarningTableCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(EarlyWarningListModel *)model {
    _model = model;
    self.stateNameLabel.text = model.statusName;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:model.startTime];
    [formatter setDateFormat:@"M月dd日 HH:mm"];
    NSString *startTimeStr = [formatter stringFromDate:date];
    
    self.stayTimeLabel.text = startTimeStr;
    self.statementLabel.text = [NSString stringWithFormat:@"在%@停留超过%@分钟", model.regions, model.stopTime];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.yuanImageView.layer.masksToBounds = YES;
    self.yuanImageView.layer.cornerRadius = CGRectGetWidth(self.yuanImageView.bounds) / 2.0;
    self.yuanImageView.backgroundColor = [UIColor redColor];
    self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
