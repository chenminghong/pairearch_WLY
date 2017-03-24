//
//  AppDelegate.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "RootTabController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![LoginViewController isLogin]) {
        [self loginPage];
    } else {
        [self mainAppPage];
    }
    
    //注册本地通知
    [self registerLocalNotification];
    
    //网络变化执行动作
    [self netWorkDidChangeAction];
    return YES;
}

//切换回登录页
- (void)loginPage {
    LoginViewController *loginVC = [LoginViewController new];
    NavigationController *loginNC = [[NavigationController alloc] initWithRootViewController:loginVC];
    [self.window setRootViewController:loginNC];
}

//切换回首页
- (void)mainAppPage {
    RootTabController *rootTab = [RootTabController new];
    [self.window setRootViewController:rootTab];
}

//注册本地通知
- (void)registerLocalNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
}

//网络变化通知
- (void)netWorkDidChangeAction {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                [self addNetLocalNotificationWithDesStr:@"网络连接已断开，请检查网络！"];
            } else {
                [MBProgressHUD bwm_showTitle:@"网络连接已断开，请检查网络！" toView:self.window hideAfter:HUD_HIDE_TIMEINTERVAL];
            }
        }
    }];
    [manager startMonitoring];
    
}

//添加本地通知
- (void)addNetLocalNotificationWithDesStr:(NSString *)desStr {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.body = [NSString localizedUserNotificationStringForKey:desStr arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    NSString *requestIdentifier = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:nil];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"本地通知添加成功");
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
