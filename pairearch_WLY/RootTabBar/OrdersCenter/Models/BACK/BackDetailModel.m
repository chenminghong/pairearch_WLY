//
//  BackDetailModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BackDetailModel.h"

@implementation BackDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.selected = @1;
    }
    return self;
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:ORDER_DETAIL_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        if (!endBlock) {
            return;
        }
        NSInteger resultFlag = [[responseObject objectForKey:@"status"] integerValue];
        //如果resultFlag是NO，说明用户名和密码不正确，直接return
        if (resultFlag == 0) {
            [hud hide:NO];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            endBlock(nil, [NSError errorWithDomain:PAIREACH_BASE_URL code:resultFlag userInfo:@{ERROR_MSG:msg}]);
        } else {
            [hud hide:YES];
            NSArray *dictArr = [NSArray arrayWithArray:[responseObject objectForKey:@"orders"]];
            //将登录成功返回的数据存到model中
            NSArray *models = [BackDetailModel getModelsWithDicts:dictArr];
            endBlock(models, nil);
        }
    } failure:^(NSError *error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

- (void)setTO_DLVY_DTT:(NSString *)TO_DLVY_DTT {
    _TO_DLVY_DTT = [TO_DLVY_DTT substringToIndex:10];
}

- (void)setFRM_DPND_CMTD_STRT_DTT:(NSString *)FRM_DPND_CMTD_STRT_DTT {
    NSInteger length = FRM_DPND_CMTD_STRT_DTT.length;
    if (length >= 9) {
        _FRM_DPND_CMTD_STRT_DTT = [FRM_DPND_CMTD_STRT_DTT substringFromIndex:length-8];
    } else {
        _FRM_DPND_CMTD_STRT_DTT = FRM_DPND_CMTD_STRT_DTT;
    }
}

- (void)setFRM_DPND_CMTD_END_DTT:(NSString *)FRM_DPND_CMTD_END_DTT {
    NSInteger length = FRM_DPND_CMTD_END_DTT.length;
    if (length >= 9) {
        _FRM_DPND_CMTD_END_DTT = [FRM_DPND_CMTD_END_DTT substringFromIndex:length-8];
    } else {
        _FRM_DPND_CMTD_END_DTT = FRM_DPND_CMTD_END_DTT;
    }
}
@end
