//
//  CBCLabel.m
//  CBCSZ
//
//  Created by ych on 13-11-15.
//  Copyright (c) 2013年 ych. All rights reserved.
//
#define kTextFont [UIFont boldSystemFontOfSize:13]
#define kTextColor [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]
#define PaomaLabelTimerInterval 0.1

#import "PaomaLabel.h"

@interface PaomaLabel () {
    NSTimer *_timer;
}
@end

static NSInteger moveTimes;
static NSInteger anotherTimers;

@implementation PaomaLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    moveTimes = -1;
    anotherTimers = 0;
    if (nil != _timer) {
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:PaomaLabelTimerInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

- (void)timerAction {
    moveTimes++;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:_font == nil ? kTextFont:_font}];
    if (size.width > self.frame.size.width) {
        CGFloat perDistance = (size.width / _text.length) / 8;//每次移动8分之一个字的宽度
        CGFloat moveDistance = -(moveTimes * perDistance);
        
        if (fabs(moveDistance) >= size.width) {
            //这个距离已经将文字移出屏幕可显示区域
            //让文字从最后边开始出现
            moveDistance = self.frame.size.width - anotherTimers * perDistance;
            moveTimes = - (anotherTimers + 1);
            anotherTimers = 0;
        }
        
        CGRect dRect = (CGRect){moveDistance, 3 * kHeightProportion, size.width, self.frame.size.height};
        [nil == _textColor? kTextColor:_textColor set];
        [self.text drawInRect:dRect withAttributes:@{NSFontAttributeName:_font == nil? kTextFont:_font}];
        
        CGFloat aDistance = (self.frame.size.width / 2);//首尾文字的间隔
        if (moveDistance < 0 && (moveDistance + size.width) < aDistance) {
            //当文字即将移出屏幕时，在右侧开始绘制起始的几个文
            anotherTimers++;
            CGFloat appearTextLength = size.width + moveDistance;//还在显示的文字的长度
            CGFloat remainDistance = self.frame.size.width - appearTextLength - aDistance;//剩下的可以用于绘制文字的长度
            
            NSInteger subStringIndex = remainDistance / perDistance;
            NSString *subText = [_text substringToIndex:MIN(subStringIndex, _text.length - 1)];
            
            [subText drawInRect:(CGRect){self.frame.size.width - remainDistance, 3 * kHeightProportion, self.frame.size.width, self.frame.size.height} withAttributes:@{NSFontAttributeName:_font == nil? kTextFont:_font}];
        }
        
        if (nil == _timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:PaomaLabelTimerInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
    } else {
        [nil == _textColor? kTextColor:_textColor set];
        [self.text drawInRect:self.bounds withAttributes:@{NSFontAttributeName:_font == nil ? kTextFont:_font}];
    }
}

- (void)removeFromSuperview {
    [_timer invalidate];
    _timer = nil;
}



@end
