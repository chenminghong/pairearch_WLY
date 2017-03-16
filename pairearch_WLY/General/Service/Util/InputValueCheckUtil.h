//
//  InputValueCheckUtil.h
//  iFuWoiPhone
//
//  Created by arvin on 16/6/21.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputValueCheckUtil : NSObject

+ (BOOL)checkNum:(NSString *)num;
+ (BOOL)checkPhoneNum:(NSString *)phone;
+ (BOOL)checkEMail:(NSString *)email;
+ (BOOL)checkPassword:(NSString *)password;
+ (BOOL)checkImageCode:(NSString *)code;
+ (BOOL)checkUserName:(NSString *)name;
+ (BOOL)checkDecimal:(NSString *)decimal;
@end
