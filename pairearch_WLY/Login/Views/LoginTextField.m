//
//  LgoinTextField.m
//  WLY
//
//  Created by Leo on 16/3/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat height = CGRectGetHeight(self.bounds);
        self.iconImageView = [UIImageView new];
        self.iconImageView.frame = CGRectMake(height / 4, height / 4, height / 2, height / 2);
    }
    return _iconImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = self.iconImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        [self addTarget:self action:@selector(textDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}

- (void)textDidChangeAction:(LoginTextField *)sender {
    if (sender.text.length != 0) {
        if (![sender.iconName containsString:@"-sel"]) {
            NSString *iconName = [NSString stringWithFormat:@"%@%@", sender.iconName, @"-sel"];
            sender.iconName = iconName;
        }
    } else {
        if ([sender.iconName containsString:@"-sel"]) {
            NSString *iconName = [sender.iconName stringByReplacingOccurrencesOfString:@"-sel" withString:@""];
            sender.iconName = iconName;
        }
    }
}

@end
