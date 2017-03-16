//
//  WQLPaoMaView.m
//  WQLPaoMaView
//
//  Created by WQL on 15/12/28.
//  Copyright © 2015年 WQL. All rights reserved.
//

#import "WQLPaoMaView.h"

#define VERTEX  SCROOL_SPEED  50.0  //跑马灯的匀速运动速度

@interface WQLPaoMaView() {
    //左侧label的frame
    CGRect currentFrame;
    
    //右侧label的frame
    CGRect behindFrame;
    
    //存放左右label的数组
    NSMutableArray *labelArray;

    //label的高度
    CGFloat labelHeight;
    
    //当前label宽度
    CGFloat calcuWidth;
    
    //是否为暂停状态
    BOOL isStop;
    
    //当前的显示内容
    NSString *currentTitle;
}

@property (nonatomic, strong) UIView *showContentView;

@property (nonatomic, assign) NSUInteger currentIndex; //当前所展示的文字下标

@property (nonatomic, strong) UIImageView *imgView; //跑马灯的title图片

@end

@implementation WQLPaoMaView

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetHeight(self.bounds) - 10, CGRectGetHeight(self.bounds) - 10)];
        self.imgView.image = [UIImage imageNamed:@"guangbo"];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = CGRectGetWidth(self.imgView.bounds) / 2.0;
        self.imgView.layer.borderColor = MAIN_THEME_COLOR.CGColor;
        self.imgView.layer.borderWidth = 1.0;
        self.imgView.backgroundColor = [UIColor whiteColor];
    }
    return _imgView;
}

- (UIView *)showContentView {
    if (!_showContentView) {
        _showContentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 5, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _showContentView.clipsToBounds = YES;
    }
    return _showContentView;
}


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.showContentView];
        
        CGFloat viewHeight = CGRectGetHeight(self.showContentView.bounds);
        labelHeight = viewHeight;
        currentTitle = title;
        //计算文本的宽度
        calcuWidth = [self widthForTextString:title height:labelHeight fontSize:16.0f];
        if (calcuWidth <= CGRectGetWidth(self.showContentView.bounds)) {
            calcuWidth = CGRectGetWidth(self.showContentView.bounds);
        }
        
        //这两个frame很重要 分别记录的是左右两个label的frame 而且后面也会需要到这两个frame
        currentFrame = CGRectMake(CGRectGetWidth(self.bounds) - calcuWidth, 0, calcuWidth, labelHeight);
        behindFrame = CGRectMake(currentFrame.origin.x+currentFrame.size.width, 0, calcuWidth, labelHeight);
        [self resetLabelWithTitle:currentTitle];
    }
    return self;
}

//开始动画
- (void)startAnimation {
    CGFloat begain = calcuWidth - CGRectGetWidth(self.showContentView.bounds);
    [self doFirstAnimationWithWidth:begain];
}


//根据title创建label
- (void)resetLabelWithTitle:(NSString *)title {
    UILabel *labelOne = [UILabel new];
    labelOne.text = title;
    labelOne.textColor = UIColorFromRGB(0x666666);
    labelOne.font = [UIFont systemFontOfSize:16.0f];
    labelOne.frame = currentFrame;
    labelOne.layer.drawsAsynchronously = YES;
    [self.showContentView addSubview:labelOne];
    labelArray  = [NSMutableArray arrayWithObject:labelOne];
    
    //如果文本的宽度大于视图的宽度才开始跑
    UILabel *abelTwo = [UILabel new];
    labelOne.layer.drawsAsynchronously = YES;
    abelTwo.frame = behindFrame;
    abelTwo.text = title;
    abelTwo.textColor = UIColorFromRGB(0x666666);
    abelTwo.font = [UIFont systemFontOfSize:16.0f];
    [labelArray addObject:abelTwo];
    [self.showContentView addSubview:abelTwo];
}


//移除显示过后的label
- (void)deleteLabelsFromArr {
    NSArray *tempArr = [NSArray arrayWithArray:labelArray];
    for (UILabel *label in tempArr) {
        [label.layer removeAllAnimations];
        [label removeFromSuperview];
        [labelArray removeObject:label];
    }
}

//先做同等速度的匀速运动
- (void)doFirstAnimationWithWidth:(CGFloat)Width {
    UILabel *lableOne = labelArray[0];
    UILabel *lableTwo = labelArray[1];
    
    //让两个label向左平移
    lableOne.transform = CGAffineTransformMakeTranslation(Width, 0);
    lableTwo.transform = CGAffineTransformMakeTranslation(Width, 0);
    
    [UIView animateWithDuration:Width / 50 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        lableOne.transform = CGAffineTransformMakeTranslation(0, 0);
        lableTwo.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self doAnimation];
    }];
}


//继续做重复的匀速运动
- (void)doAnimation {
    //取到两个label
    UILabel *lableOne = labelArray[0];
    UILabel *lableTwo = labelArray[1];
    
    lableOne.transform = CGAffineTransformMakeTranslation(0, 0);
    lableTwo.transform = CGAffineTransformMakeTranslation(0, 0);
    
    CGFloat width = CGRectGetWidth(currentFrame);
    
    //UIViewAnimationOptionCurveLinear是为了让lable做匀速动画
    [UIView animateWithDuration:width / 50 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //让两个label向左平移
        lableOne.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
        lableTwo.transform = CGAffineTransformMakeTranslation(-currentFrame.size.width, 0);
        
    } completion:^(BOOL finished) {
        if (finished) {
            //递归调用
            [self doAnimation];
        }
    }];
}

//计算文字宽度
- (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
}

- (void)start {
    UILabel *lableOne = labelArray[0];
    [self resumeLayer:lableOne.layer];
    
    UILabel *lableTwo = labelArray[1];
    [self resumeLayer:lableTwo.layer];
    
    isStop = NO;
}

- (void)stop {
    UILabel *lableOne = labelArray[0];
    [self pauseLayer:lableOne.layer];
    
    UILabel *lableTwo = labelArray[1];
    [self pauseLayer:lableTwo.layer];
    
    isStop = YES;
}

//暂停动画
- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}

//恢复动画
- (void)resumeLayer:(CALayer*)layer {
    //当你是停止状态时，则恢复
    if (isStop) {
        CFTimeInterval pauseTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pauseTime;
        layer.beginTime = timeSincePause;
    }
}

@end
