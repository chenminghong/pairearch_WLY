//
//  LoginModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : NSObject
/*
 {
    cpDriver = {
        code = 22104;  //司机的id
        createDate = "2017-02-23 17:56:55"; //用户的创建时间
        createUser = 102admin; //创建者
        driverCardUrl = 37;  //身份证号对应的链接地址的表的id
        id = 22104;  //表的id
        idCard = 111111111111112;  //身份证号
        lastLoginTime = "2017-02-23 19:08:28"; //最近一次登录的时间
        logicState = 1;
        modifyDate = "2017-02-10 12:24:45";  //修改时间
        modifyUser = 102admin;  //修改人
        name = "\U5b8f\U8c611"; //用户名
        pwd = e10adc3949ba59abbe56e057f20f883e;  //密码
        tel = 18100000001;  //电话号码
    };
    loginResult = 1;
    remark = "\U767b\U5f55\U6210\U529f\Uff01\Uff01";
 }
 */

@property (nonatomic, copy) NSString *code;  //司机的id

@property (nonatomic, copy) NSString *createDate;  //用户的创建时间

@property (nonatomic, copy) NSString *createUser;  //创建者

@property (nonatomic, copy) NSString *driverCardUrl;  //身份证号对应的链接地址的表的id

@property (nonatomic, copy) NSString *userId;  //表的id

@property (nonatomic, copy) NSString *idCard; //身份证号

@property (nonatomic, copy) NSString *lastLoginTime;  //身份证号

@property (nonatomic, copy) NSString *logicState;

@property (nonatomic, copy) NSString *modifyDate;  //修改时间

@property (nonatomic, copy) NSString *modifyUser; //修改人

@property (nonatomic, copy) NSString *name; //用户名

@property (nonatomic, copy) NSString *pwd;  //密码

@property (nonatomic, copy) NSString *tel;  //密码


//初始化
+ (instancetype)shareLoginModel;

//是否登录
+ (BOOL)isLoginState;

//初始化数据
- (void)initData;

//更新用户信息数据
- (void)updateUserInfoWithInfoDict:(NSDictionary *)infoDict;

//修改某一条信息
+ (void)updateInfoValue:(NSString *)infoValue forKey:(NSString *)key;

//请求登录数据
+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock;

@end
