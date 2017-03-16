//
//  CommonBackModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonBackModel.h"

@implementation CommonBackModel

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:PRDER_BACK_CHECK_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            [hud hide:YES];
            NSArray *detailModelList = [CommonBackModel getModelsWithDicts:responseObject[@"data"]];
            for (CommonBackModel *model in detailModelList) {
                model.truckNum = responseObject[@"truckNum"];
                model.trucType = responseObject[@"trucType"];
            }
            endBlock(detailModelList, nil);
        } else {
            [hud hide:NO];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:status userInfo:@{ERROR_MSG:msg}];
            endBlock(nil, error);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
