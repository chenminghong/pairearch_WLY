//
//  FileDirPathUtil.m
//  iFuWoiPhone
//
//  Created by arvin on 16/6/15.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "FileDirPathUtil.h"

@implementation FileDirPathUtil

+ (NSString *)cachesDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)tmpDir
{
    return NSTemporaryDirectory();
}

+ (NSString *)documentsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

+ (NSString *)homeDir
{
    return NSHomeDirectory();
}

+ (NSString *)mainBundlePath:(NSString *)name
{
    NSArray *nameAndType = [name componentsSeparatedByString:@"."];
    if (nameAndType.count==2) {
        return [[NSBundle mainBundle] pathForResource:nameAndType[0] ofType:nameAndType[1]];
    }
    return nil;
}

+ (BOOL)fileExistAt:(NSString *)path
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileMgr fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)dirExistAt:(NSString *)path
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileMgr fileExistsAtPath:path isDirectory:&isDir]) {
        if (isDir) {
            return YES;
        }
    }
    return NO;
}

+ (void)fileDeleteAt:(NSString *)path
{
    if ([FileDirPathUtil fileExistAt:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void)fileCopy:(NSString *)srcPath andDestPath:(NSString *)destPath
{
    if ([FileDirPathUtil fileExistAt:srcPath]) {
        if ([FileDirPathUtil fileExistAt:destPath]) {
            [FileDirPathUtil fileDeleteAt:destPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:nil];
    }
}

+ (void)dirDeleteAt:(NSString *)path
{
    if ([FileDirPathUtil dirExistAt:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void)dirDeleteAt:(NSString *)path andType:(NSString *)type
{
    if ([FileDirPathUtil dirExistAt:path]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
            }
        }
    }
}

+ (void)dirCreateAt:(NSString *)path
{
    if (![FileDirPathUtil dirExistAt:path]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)dirCopy:(NSString *)srcPath andDestPath:(NSString *)destPath
{
    if ([FileDirPathUtil dirExistAt:srcPath]) {
        if (![FileDirPathUtil dirExistAt:destPath]) {
            [FileDirPathUtil dirCreateAt:destPath];
        }else{
            [FileDirPathUtil dirDeleteAt:destPath];
            [FileDirPathUtil dirCreateAt:destPath];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:srcPath error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            NSString *srcFilePath = [srcPath stringByAppendingPathComponent:filename];
            NSString *destFilePath = [destPath stringByAppendingPathComponent:filename];
            if ([FileDirPathUtil fileExistAt:srcFilePath]) {
                [FileDirPathUtil fileCopy:srcFilePath andDestPath:destFilePath];
            }
            if ([FileDirPathUtil dirExistAt:srcFilePath]) {
                [FileDirPathUtil dirCopy:srcFilePath andDestPath:destFilePath];
            }
        }
    }
}

@end
