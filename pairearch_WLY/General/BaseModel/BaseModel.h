//
//  BaseModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//初始化Model
- (instancetype)initWithDict:(NSDictionary *)dict;

//初始化Model
+ (instancetype)getModelWithDict:(NSDictionary *)dict;

//初始化Model
+ (NSArray *)getModelsWithDicts:(NSArray *)dicts;

//验证登录是否成功
+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id model, NSError *error))endBlock;

//网络接口请求添加签名参数sign  ?不起作用啊
+ (NSDictionary *)signReqParams:(NSDictionary *)paramDict;

//获取MAC地址
+ (NSString *)getMacAddress;

//密码MD5加密
+ (NSString *)md5HexDigest:(NSString*)password;

//获取设备型号
+ (NSString *)iphoneType;

//计算文字的高度(定宽)
+ (CGFloat)heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize;

//计算文字的宽度(定高)
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;



@end
