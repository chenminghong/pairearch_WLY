//
//  NetworkHelper.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (instancetype)shareClient {
    static NetworkHelper *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedClient = [[NetworkHelper alloc] initWithBaseURL:[NSURL URLWithString:PAIREACH_BASE_URL]];
//        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [sharedClient.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
        sharedClient.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    });
    return sharedClient;
}

+ (instancetype)shareClientOther {
    static NetworkHelper *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[NetworkHelper alloc] initWithBaseURL:nil];
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        [_sharedClient.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
        sharedClient.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    });
    
    return sharedClient;
}

//判断网络状态
+ (NetworkReachabilityStatus)localizedNetworkReachabilityStatus {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return NetworkReachabilityStatusNotReachable;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NetworkReachabilityStatusReachableViaWWAN;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NetworkReachabilityStatusReachableViaWiFi;
        case AFNetworkReachabilityStatusUnknown:
        default:
            return NetworkReachabilityStatusUnknown;
    }
}

// 判断网络类型
+ (NetworkStatus)getNetworkStatus {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStatus status = NetworkStatusNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    status = NetworkStatusNone;
                    //无网模式
                    break;
                case 1:
                    status = NetworkStatus2G;
                    break;
                case 2:
                    status = NetworkStatus3G;
                    break;
                case 3:
                    status = NetworkStatus4G;
                    break;
                case 5:
                    status = NetworkStatusWIFI;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return status;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject))success failure:(void (^)(NSError *))failure {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClient] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task, hud, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSError *))failure {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClient] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        if (success) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSError *error))failure {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:window title:nil animated:YES];
    return [[NetworkHelper shareClient] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            [hud hide:NO];
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        if (failure) {
            failure(error);
        }
    }];
}




@end
