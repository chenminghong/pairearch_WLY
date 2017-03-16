//
//  URLHandleUtil.m
//  iFuWoiPhone
//
//  Created by arvin on 16/6/30.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "URLHandleUtil.h"

@implementation URLHandleUtil


+ (NSString *)URLEncode:(NSString *)str
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}


+ (NSString *)URLDecode:(NSString *)str
{
    return [str stringByRemovingPercentEncoding];
}



@end
