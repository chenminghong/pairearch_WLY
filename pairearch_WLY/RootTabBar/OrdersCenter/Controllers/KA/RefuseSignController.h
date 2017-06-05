//
//  RefuseSignController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefuseSignBlock)(NSDictionary *signResult);

@interface RefuseSignController : BaseViewController

@property (nonatomic, strong) NSDictionary *paraDict;  //参数

@property (nonatomic, copy) NSString *loadNumber;

@property (nonatomic, assign) NSInteger lxCode;  //类型编码:lxCode;(JJQS,YCQS,YCTL) 拒绝签收 异常签收 异常停留

@property (nonatomic, assign) BOOL isBackRoot;

@property (nonatomic, copy) RefuseSignBlock signResultBlock;   //拒绝/异常签收处理结果


+ (RefuseSignController *)pushToRefuseSignWithController:(UIViewController *)controller signResultBlock:(RefuseSignBlock)signResultBlock;

@end
