//
//  AlertInfoUtil.m
//  iFuWoiPhone
//
//  Created by arvin on 16/6/20.
//  Copyright © 2016年 fuwo. All rights reserved.
//

#import "AlertInfoUtil.h"

@implementation AlertInfoUtil

+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

+ (MBProgressHUD *)setupHUD
{
    [self alertHide];
    
    MBProgressHUD *hud = \
    [MBProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    hud.backgroundColor = [UIColor clearColor];
    //hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    //hud.bezelView.color = [UIColor whiteColor];
    //hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)alertInfo:(NSString *)info andTime:(CGFloat)time
{
    
    MBProgressHUD *hud = [self setupHUD];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(info, @"HUD message title");
    [hud hide:YES afterDelay:time];
}

+ (void)alertInfoError:(NSError *)error andTime:(CGFloat)time
{
    NSInteger code = error.code;
    if (code > 10000) {
        NSString *message = error.userInfo[ERRORMSG];
        [AlertInfoUtil alertInfo:message andTime:time];
    }else{
        if (code < 10000 && code != -999) {
            [AlertInfoUtil alertInfo:@"请检查您的网络状态。" andTime:time];
        }
    }
}

+ (MBProgressHUD *)alertWait
{
   return [self setupHUD];
}

+ (void)alertWait:(NSString *)info
{
    MBProgressHUD *hud = [self setupHUD];
    hud.labelText = NSLocalizedString(info, @"HUD loading title");
}

+ (void)alertProgress
{
    MBProgressHUD *hud = [self setupHUD];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
}

+ (void)alertProgress:(NSString *)info
{
    MBProgressHUD *hud = [self setupHUD];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = NSLocalizedString(info, @"HUD loading title");
}

+ (void)alertSetupProgress:(CGFloat)progress
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self keyWindow]];
    if (hud&&hud.mode == MBProgressHUDModeAnnularDeterminate) {
        hud.progress = progress;
    }
}

+ (void)alertHide
{
    [MBProgressHUD hideHUDForView:[self keyWindow]  animated:YES];
}

@end
