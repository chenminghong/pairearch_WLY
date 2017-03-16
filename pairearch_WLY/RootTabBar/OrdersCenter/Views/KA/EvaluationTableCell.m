//
//  EvaluationTableCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EvaluationTableCell.h"

#import "EvaluationTableModel.h"

#define Identifier @"EvaluationTableCell"


@implementation EvaluationTableCell

#pragma mark -- Lazy Loading

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0, kScreenWidth - 60.0, 30)];
        self.contentLabel.font = [UIFont systemFontOfSize:13.0];
        self.contentLabel.text = @"1.工厂处理效率满意度";
    }
    return _contentLabel;
}

- (CWStarRateView *)starView {
    if (!_starView) {
        self.starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(30.0, 30.0, 150, 25) numberOfStars:5];
        self.starView.scorePercent = 0.0;
        self.starView.delegate = self;
    }
    return _starView;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        self.separatorView = [UIView new];
        [self.contentView addSubview:self.separatorView];
        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).with.offset(30);
            make.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        self.separatorView.backgroundColor = TABLE_SEPARATOR_COLOR;
    }
    return _separatorView;
}

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    EvaluationTableCell *cell = [table dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[EvaluationTableCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.starView];
        [self.contentView addSubview:self.separatorView];
    }
    return self;
}

- (void)setModel:(EvaluationTableModel *)model {
    _model = model;
    self.contentLabel.text = model.statementStr;
}

#pragma mark -- CWStarRateViewDelegate

//星级评分分值变化返回分值代理方法
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    self.model.score = [NSString stringWithFormat:@"%.0f", round(newScorePercent/0.2)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
