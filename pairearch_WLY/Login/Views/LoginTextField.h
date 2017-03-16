//
//  LgoinTextField.h
//  WLY
//
//  Created by Leo on 16/3/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextField : UITextField

@property (nonatomic, strong) UIImageView *iconImageView;  //左视图

@property (nonatomic, strong) NSString *iconName; //左视图的图片；

- (void)textDidChangeAction:(LoginTextField *)sender;

@end
