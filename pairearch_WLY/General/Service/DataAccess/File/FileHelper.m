//
//  FileHelper.m
//  iFuWoiPhone
//
//  Created by arvin on 16/6/15.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (FileHelper *)shareClient
{
    static FileHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FileHelper alloc] init];
    });
    
    return _sharedClient;
}

- (NSString *)absolutePaht:(NSString *)path
{
    NSArray *comArr = [path componentsSeparatedByString:@"/"];
    if (comArr.count == 1) {
        // 默认位Caches目录保存数据
        path = [[FileDirPathUtil cachesDir] stringByAppendingPathComponent:path];
    }
    return path;
}

// 读取文件数据
- (NSData *)readData:(NSString *)path
{
    path = [self absolutePaht:path];
    return [[NSData alloc] initWithContentsOfFile:path];
}
- (NSString *)readStr:(NSString *)path
{
    path = [self absolutePaht:path];
    return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}
- (NSDictionary *)readDict:(NSString *)path
{
    path = [self absolutePaht:path];
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}

// 写入文件数据
- (BOOL)writeData:(NSString *)path andData:(NSData *)data
{
    path = [self absolutePaht:path];
    return [data writeToFile:path atomically:YES];
}
- (BOOL)writeStr:(NSString *)path andData:(NSString *)str
{
    path = [self absolutePaht:path];
    return [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (BOOL)writeDict:(NSString *)path andData:(NSDictionary *)dict
{
    path = [self absolutePaht:path];
    return [dict writeToFile:path atomically:YES];
}

// UserDefault
+ (id)readUserDefaultWithKey:(NSString *)key {
    if (key&&key.length) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)writeUserDefault:(NSString *)key andValue:(id)value {
    if (key&&key.length&&value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)clearUserDefault:(NSString *)key {
    if (key&&key.length) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
