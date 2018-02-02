//
//  AppDelegate.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//切换回登录页
- (void)loginPage;

//切换回首页
- (void)mainAppPage;

/**
 移除相应的通知
 
 @param identifier 需要移除的通知的唯一标识
 */
+ (void)removePendingLocalNotificationWithIdentifier:(NSString *)identifier;

/**
 移除所有的通知
 */
+ (void)removeAllPendingLocalNotification;

@end

