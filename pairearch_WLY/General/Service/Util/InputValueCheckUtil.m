//
//  InputValueCheckUtil.m
//  iFuWoiPhone
//
//  Created by arvin on 16/6/21.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "InputValueCheckUtil.h"

#define RGNUMBER        @"^[0-9]*$"
#define RGPHONENUM      @"^1[34578]\\d{9}$"
#define RGEMAIL         @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$"
#define RGPASSWORD      @"^[a-zA-Z0-9]{6,20}$"
#define RGIMAGECODE     @"^[a-zA-Z0-9]{4}$"
#define RGUSERNAME      @"^[a-zA-Z\u4E00-\u9FA5]{1,20}"

#define RGDECIMAL        @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$"
@implementation InputValueCheckUtil

+ (BOOL)check:(NSString *)regular andSrc:(NSString *)src
{
    if (!src||src.length == 0) {
        return NO;
    }
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [numberPre evaluateWithObject:src];
}

+ (BOOL)checkNum:(NSString *)num
{
    return [self check:RGNUMBER andSrc:num];
}

+ (BOOL)checkPhoneNum:(NSString *)phone
{
    return [self check:RGPHONENUM andSrc:phone];
}

+ (BOOL)checkEMail:(NSString *)email
{
    return [self check:RGEMAIL andSrc:email];
}

+ (BOOL)checkPassword:(NSString *)password
{
    return [self check:RGPASSWORD andSrc:password];
}

+ (BOOL)checkImageCode:(NSString *)code
{
    return [self check:RGIMAGECODE andSrc:code];
}
//用户名
+ (BOOL)checkUserName:(NSString *)name
{
    return YES;
   //return [self check:RGUSERNAME andSrc:name];
}
+ (BOOL)checkDecimal:(NSString *)decimal
{
    return [self check:RGDECIMAL andSrc:decimal];
}

@end
