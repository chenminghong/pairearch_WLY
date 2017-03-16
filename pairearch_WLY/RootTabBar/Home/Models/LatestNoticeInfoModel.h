//
//  LatestNoticeInfoModel.h
//  WLY
//
//  Created by Leo on 16/3/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LatestNoticeInfoModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, strong) NSNumber *createUser;
@property (nonatomic, copy) NSString *iD;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, strong) NSNumber *logicState;
@property (nonatomic, copy) NSString *modifyDate;
@property (nonatomic, copy) NSString *modifyUser;
@property (nonatomic, copy) NSString *msgIp;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *typeName;
@end
