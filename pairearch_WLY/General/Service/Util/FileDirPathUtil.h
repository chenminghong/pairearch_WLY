//
//  FileDirPathUtil.h
//  iFuWoiPhone
//
//  Created by arvin on 16/6/15.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDirPathUtil : NSObject

// gain path or dir
+ (NSString *)cachesDir;
+ (NSString *)tmpDir;
+ (NSString *)documentsDir;
+ (NSString *)homeDir;
+ (NSString *)mainBundlePath:(NSString *)name;

// exist dir or path
+ (BOOL)fileExistAt:(NSString *)path;
+ (BOOL)dirExistAt:(NSString *)path;

// file or dir delete
+ (void)fileDeleteAt:(NSString *)path;
+ (void)fileCopy:(NSString *)srcPath andDestPath:(NSString *)destPath;
+ (void)dirDeleteAt:(NSString *)path;
+ (void)dirDeleteAt:(NSString *)path andType:(NSString *)type;
+ (void)dirCreateAt:(NSString *)path;
+ (void)dirCopy:(NSString *)srcPath andDestPath:(NSString *)destPath;

@end
