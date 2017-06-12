//
//  EarlyWarningListModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/12.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EarlyWarningListModel.h"

@implementation EarlyWarningListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.abnormalId = [NSString stringWithFormat:@"%@", value];
    }
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:WARNING_LIST_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:YES];
        
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            NSArray *orders = responseObject[@"orders"];
            NSArray *ordersArr = [EarlyWarningListModel getModelsWithDicts:orders];
            if (endBlock) {
                endBlock(ordersArr, nil);
            }
        } else {
            NSString *msg = responseObject[@"msg"];
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:status userInfo:@{ERROR_MSG:msg}];
            if (endBlock) {
                endBlock(nil, error);
            }
        }
        
    } failure:^(NSError *error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

@end
