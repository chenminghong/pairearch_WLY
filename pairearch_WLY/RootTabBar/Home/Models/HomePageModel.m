//
//  HomePageModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel


+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:HOME_PAGE_DATA_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        NSString *msg = responseObject[@"msg"];
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            [hud hide:YES];
            NSString *type = responseObject[@"type"];
            NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
            NSArray *modelsArr = [HomePageModel getModelsWithDicts:data];
            for (HomePageModel *model in modelsArr) {
                model.type = type;
            }
            endBlock(modelsArr, nil);
        } else {
            [hud hide:NO];
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:status userInfo:@{ERROR_MSG:msg}];
            endBlock(nil, error);
        }
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}


@end
