
//
//  DetailCommonModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "DetailCommonModel.h"

@implementation DetailCommonModel


+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:ORDER_DETAIL_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
            [hud hide:YES];
            NSArray *detailModelList = [DetailCommonModel getModelsWithDicts:responseObject[@"orders"]];
            endBlock(detailModelList, nil);
        } else {
            [hud hide:NO];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:status userInfo:@{ERROR_MSG:msg}];
            endBlock(nil, error);
        }
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}

- (NSString *)BW_WGT {
    return [NSString stringWithFormat:@"%.3f", ([_BW_WGT integerValue] / 1000.0)];
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
