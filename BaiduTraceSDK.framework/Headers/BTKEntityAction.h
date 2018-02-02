//
//  BTKEntityAction.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAddEntityRequest.h"
#import "BTKDeleteEntityRequest.h"
#import "BTKUpdateEntityRequest.h"
#import "BTKQueryEntityRequest.h"
#import "BTKSearchEntityRequest.h"
#import "BTKBoundSearchEntityRequest.h"
#import "BTKAroundSearchEntityRequest.h"
#import "BTKEntityDelegate.h"

/// entity终端的相关操作，包括entity的增、删、改、查
/**
 entity终端的相关操作，包括entity的增、删、改、查
 */
@interface BTKEntityAction : NSObject

/**
 entity相关操作单例的全局访问点

 @return 单例对象
 */
+(BTKEntityAction *)sharedInstance;

#pragma mark - 终端管理
/**
 创建entity，并赋属性信息

 @param request 添加entity的请求对象
 @param delegate entity操作结果的回调对象
 */
-(void)addEntityWith:(BTKAddEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 删除entity

 @param request 删除entity的请求对象
 @param delegate entity操作结果的回调对象
 */
-(void)deleteEntityWith:(BTKDeleteEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 更新entity属性信息

 @param request 修改entity的请求对象
 @param delegate entity操作结果的回调对象
 */
-(void)updateEntityWith:(BTKUpdateEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 检索符合过滤条件的entity，返回entity属性信息和最新位置，可用于列出entity，也可用于批量查询多个entitiy的位置。

 @param request 查询entity的请求对象
 @param delegate entity操作结果的回调对象
 */
-(void)queryEntityWith:(BTKQueryEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

#pragma mark - 实时位置搜索
/**
 根据关键字搜索entity，并返回实时位置。

 @param request 搜索entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)searchEntityWith:(BTKSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 根据矩形地理范围搜索entity，并返回实时位置

 @param request 搜索entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)boundSearchEntityWith:(BTKBoundSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 根据圆心半径搜索entity，并返回实时位置

 @param request 搜索entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)aroundSearchEntityWith:(BTKAroundSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

@end
