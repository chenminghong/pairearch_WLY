//
//  OrderDetailModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/2.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.selected = @1;
    }
    return self;
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:ORDER_DETAIL_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            [hud hide:YES];
            NSArray *detailModelList = [OrderDetailModel getModelsWithDicts:responseObject[@"orders"]];
            endBlock(detailModelList, nil);
        } else {
            [hud hide:NO];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:status userInfo:@{ERROR_MSG:msg}];
            endBlock(nil, error);
        }
        
    } failure:^(NSError *error) {
        endBlock(nil, error);
        NSLog(@"%@", error.userInfo[@"NSLocalizedDescription"]);
    }];
}

@end
