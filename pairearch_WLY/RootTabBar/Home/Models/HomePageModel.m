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
    return [[NetworkHelper shareClient] GET:HOME_PAGE_DATA_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSInteger status = [responseDict[@"status"] integerValue];
        if (status == 1) {
            NSString *type = responseDict[@"type"];
            NSArray *data = [NSArray arrayWithArray:responseDict[@"data"]];
            NSArray *modelsArr = [HomePageModel getModelsWithDicts:data];
            for (HomePageModel *model in modelsArr) {
                model.type = type;
            }
            endBlock(modelsArr, nil);
        } else {
            endBlock([NSMutableArray array], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        endBlock(nil, error);
    }];
}


@end
