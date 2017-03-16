//
//  PublicUtil.h
//  iFuWoiPhone
//
//  Created by 爱福窝 on 16/6/16.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#ifndef PublicUtil_h
#define PublicUtil_h

//屏幕宽高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//颜色RGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//设置字体的大小
#define FONT(font) [UIFont systemFontOfSize:font]

//判断系统版本
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_6_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)? (YES):(NO))
#define IOS_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define IOS_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define IOS_9_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))

//判断设备
#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define isRetina ([[UIScreen mainScreen] scale] > 1 ? YES : NO)


//适配屏幕
#define SCALE_WIDTH  [UIScreen mainScreen].bounds.size.width/375.0
#define SCALE_HEIGHT    [UIScreen mainScreen].bounds.size.height/667.0

//
#define IMGSIZE @".960x1600.jpg" //640X1000
#define IMGSIZE_S @".240x240.jpg" //640X1000

#define IOS_10_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)? (YES):(NO))
#endif /* PublicUtil_h */
