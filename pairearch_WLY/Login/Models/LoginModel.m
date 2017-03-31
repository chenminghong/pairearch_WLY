//
//  LoginModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LoginModel.h"

#import <CommonCrypto/CommonDigest.h>

@implementation LoginModel

//初始化
+ (instancetype)shareLoginModel {
    static LoginModel *loginModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModel = [LoginModel new];
    });
    return loginModel;
}

//初始化数据
- (void)initData {
    NSDictionary *userInfo = [LoginModel readUserInfo];
    if (userInfo) {
        [self setValuesForKeysWithDictionary:userInfo];
    }
    if (self.name && self.tel) {
        [[LocationUploadManager shareManager] setEntityWithEntityName:[NSString stringWithFormat:@"%@_%@", [LoginModel shareLoginModel].name, [LoginModel shareLoginModel].tel]];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.userId = [NSString stringWithFormat:@"%@", value];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setTel:(NSString *)tel {
    _tel = tel;
    //开启定位上传
}

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [[NetworkHelper shareClient] POST:USER_LOGIN_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!endBlock) {
            return;
        }
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger resultFlag = [[dataDict objectForKey:@"loginResult"] integerValue];
        NSString *remark = [NSString stringWithFormat:@"%@", dataDict[@"remark"]];
        
        //如果resultFlag是NO，说明用户名和密码不正确，直接return
        if (resultFlag == 0) {
            endBlock(nil, [NSError errorWithDomain:PAIREACH_BASE_URL code:resultFlag userInfo:@{ERROR_MSG:remark}]);
        } else {
            NSDictionary *responseEntity = [dataDict objectForKey:@"cpDriver"];
            //将登录成功返回的数据存到model中
            [[LoginModel shareLoginModel] updateUserInfoWithInfoDict:responseEntity];
            endBlock([LoginModel shareLoginModel], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}

//更新全部用户信息
- (void)updateUserInfoWithInfoDict:(NSDictionary *)infoDict {
    [self setValuesForKeysWithDictionary:infoDict];
    [self saveUserInfo:infoDict];
}

//修改某一条信息
+ (void)updateInfoValue:(NSString *)infoValue forKey:(NSString *)key {
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:[self readUserInfo]];
    [infoDict setValue:infoValue forKey:key];
    [[LoginModel shareLoginModel] updateUserInfoWithInfoDict:infoDict];
}

//是否登录
+ (BOOL)isLoginState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_STATE];
}

//保存用户信息数据
- (void)saveUserInfo:(NSDictionary *)userInfo {
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [FileHelper writeUserDefault:USER_INFO andValue:infoData];
}

//读取用户信息数据
+ (NSDictionary *)readUserInfo {
    NSData *userData = [FileHelper readUserDefaultWithKey:USER_INFO];
    if (userData) {
        NSDictionary *userInfoDict = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return userInfoDict;
    }
    return nil;
}

@end
