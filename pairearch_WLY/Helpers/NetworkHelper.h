//
//  NetworkHelper.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//网络请求超时的时间
#define REQUEST_TIMEOUT 10.0f

//baseUrl
#define BASE_URL  @"http://106.14.39.65:8285/itip/client/"

typedef NS_ENUM(NSUInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnknown          = -1,
    NetworkReachabilityStatusNotReachable     = 0,
    NetworkReachabilityStatusReachableViaWWAN = 1,
    NetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusNone = 0, // 没有网络
    NetworkStatus2G, // 2G
    NetworkStatus3G, // 3G
    NetworkStatus4G, // 4G
    NetworkStatusWIFI // WIFI
};

@interface NetworkHelper : AFHTTPSessionManager

//init
+ (instancetype)shareClient;

+ (instancetype)shareClientOther;

//判断网络状态
+ (NetworkReachabilityStatus)localizedNetworkReachabilityStatus;

//判断网络类型
+ (NetworkStatus)getNetworkStatus;

//get请求
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject))success failure:(void (^)(NSError *error))failure;

//post请求
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSError *error))failure;

//post请求(上传文件)
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSError *error))failure;

@end
