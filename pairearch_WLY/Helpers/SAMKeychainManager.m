//
//  SAMKeychainManager.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/29.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "SAMKeychainManager.h"

//account
#define ACCOUNT  @"Uniquely_identifies"

@implementation SAMKeychainManager

//获取唯一标识
+ (NSString *)getUniquelyIdentifies {
    NSString *identifier = [SAMKeychain passwordForService:[self getService] account:ACCOUNT];
    if (!identifier) {
        identifier = [self createUUID];
        NSError *error = nil;
        [SAMKeychain setPassword:identifier forService:[self getService] account:ACCOUNT error:&error];
        if ([error code] == errSecSuccess) {
            NSLog(@"存储ACCOUNT密码_成功");
        }else if ([error code] == errSecItemNotFound) {
            NSLog(@"存储ACCOUNT密码_失败 errSecItemNotFound");
        }else {
            NSLog(@"存储ACCOUNT密码_失败 %@", error.localizedDescription);
        }
    }
    return identifier;
}



//创建UUID
+ (NSString *)createUUID {
    NSString *uuid = [NSUUID UUID].UUIDString;
    return uuid;
}

//获取当前的bundleID
+ (NSString *)getService {
    return [NSBundle mainBundle].bundleIdentifier;
}

@end
