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
    
    //注册通知
    [self registerLocalNotification];
    
    //检查版本更新
    [self checkAppVersion];
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

//注册通知
- (void)registerLocalNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
}

//检查App版本信息
- (void)checkAppVersion {
    //构建版本获取appID
    NSString *appID = @"";
    NSString *updateUrl = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appID];
    [[NetworkHelper shareClient] GET:updateUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[receiveDic valueForKey:@"resultCount"] integerValue] > 0) {
            
//            NSString *trackViewUrl = [[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"trackViewUrl"];
            //APP最新版本
            NSString *latestVersion = [[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"];
            latestVersion = [latestVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            CGFloat latest = [latestVersion floatValue];
            
            //APP当前版本
            NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            appCurVersion = [appCurVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            CGFloat current = [appCurVersion floatValue];
            
            latest = 1.2;
            current = 1.1;
            if (latest > current) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"发现需要升级的版本，现在去更新？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/yi-ka-tongbic-ban/id1139094792?l=en&mt=8"]]; //跳转到App Store下载页面
                }];
                [alertView addAction:sure];
                [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
            }
        }
    } failure:nil];
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
