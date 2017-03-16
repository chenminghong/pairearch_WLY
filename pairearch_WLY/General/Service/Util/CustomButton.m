//
//  CustomButton.m
//  iFuWoPhotoiPhone
//
//  Created by 爱福窝 on 16/9/9.
//  Copyright © 2016年 com.ifuwo. All rights reserved.
//

#import "CustomButton.h"

//#define titleScale 0.68

#define margin 5

@implementation CustomButton

//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 0, contentRect.size.width * titleScale, contentRect.size.height);
//}
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(contentRect.size.width * titleScale, 0, contentRect.size.width * ( 1 - titleScale ), contentRect.size.height);
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setImage:[UIImage imageNamed:@"icon_s-xia"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"icon_s-shang"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGB(0xef4a4a) forState:UIControlStateSelected];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.titleLabel.font;
    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    CGFloat imageW = 8;
    CGFloat imageH = 6;
    
    CGFloat textX = (self.frame.size.width - (textSize.width + imageW + margin)) * 0.5;
    self.titleLabel.frame = CGRectMake(textX, 0, textSize.width, self.frame.size.height);
    self.imageView.frame = CGRectMake(margin + CGRectGetMaxX(self.titleLabel.frame), (CGRectGetHeight(self.bounds) - imageH) / 2, imageW, imageH);
}

@end
