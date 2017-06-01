//
//  RejectReasonListModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/6/1.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RejectReasonListModel.h"

@implementation RejectReasonListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.reasonId = [NSString stringWithFormat:@"%@", value];
    }
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:REJECT_REASON_LIST_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        [hud hide:NO];
        NSArray *listArr = [NSArray arrayWithArray:responseObject];
        NSArray *dataListArr = [RejectReasonListModel getModelsWithDicts:listArr];
        if (endBlock) {
            endBlock(dataListArr, nil);
        }
    } failure:^(NSError *error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

@end
