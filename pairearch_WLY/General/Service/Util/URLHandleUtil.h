//
//  URLHandleUtil.h
//  iFuWoiPhone
//
//  Created by arvin on 16/6/30.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLHandleUtil : NSObject

+ (NSString *)URLEncode:(NSString *)str;
+ (NSString *)URLDecode:(NSString *)str;

@end
