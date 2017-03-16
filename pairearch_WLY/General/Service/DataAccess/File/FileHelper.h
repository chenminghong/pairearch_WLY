//
//  FileHelper.h
//  iFuWoiPhone
//
//  Created by arvin on 16/6/15.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileDirPathUtil.h"

@interface FileHelper : NSObject

+ (FileHelper *)shareClient;

// 读取文件数据
- (NSData *)readData:(NSString *)path;
- (NSString *)readStr:(NSString *)path;
- (NSDictionary *)readDict:(NSString *)path;

// 写入文件数据
- (BOOL)writeData:(NSString *)path andData:(NSData *)data;
- (BOOL)writeStr:(NSString *)path andData:(NSString *)str;
- (BOOL)writeDict:(NSString *)path andData:(NSDictionary *)dict;

// UserDefault
+ (id)readUserDefaultWithKey:(NSString *)key;
+ (void)writeUserDefault:(NSString *)key andValue:(id)value;
+ (void)clearUserDefault:(NSString *)key;

@end
