//
//  AlertInfoUtil.h
//  iFuWoiPhone
//
//  Created by arvin on 16/6/20.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

#define AlertTime 1.0

#define ERRORMSG @"message"
#define ERRORSYS @"com.alamofire.serialization.response.error.data"
#define ERRORSYSMSG(error) [[NSString alloc] initWithData:error.userInfo[ERRORSYS] encoding:NSUTF8StringEncoding]

@interface AlertInfoUtil : NSObject

+ (void)alertInfo:(NSString *)info andTime:(CGFloat)time;
+ (void)alertInfoError:(NSError *)error andTime:(CGFloat)time;
+ (MBProgressHUD *)alertWait;
+ (void)alertWait:(NSString *)info;
+ (void)alertProgress;
+ (void)alertProgress:(NSString *)info;
+ (void)alertSetupProgress:(CGFloat)progress;
+ (void)alertHide;

@end
