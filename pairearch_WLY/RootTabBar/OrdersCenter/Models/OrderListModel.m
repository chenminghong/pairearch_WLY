//
//  OrderListModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:ORDER_LIST_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        if (!endBlock) {
            return;
        }
        NSInteger resultFlag = [[responseObject objectForKey:@"loadResult"] integerValue];
        //如果resultFlag是NO，说明用户名和密码不正确，直接return
        if (resultFlag == 0) {
            [hud hide:NO];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            endBlock(nil, [NSError errorWithDomain:PAIREACH_BASE_URL code:resultFlag userInfo:@{ERROR_MSG:msg}]);
        } else {
            [hud hide:YES];
            NSArray *dictArr = [NSArray arrayWithArray:[responseObject objectForKey:@"orders"]];
            //将登录成功返回的数据存到model中
            NSArray *models = [OrderListModel getModelsWithDicts:dictArr];
            endBlock(models, nil);
        }
    } failure:^(NSError *error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

@end
