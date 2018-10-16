/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //如之前有打开过，就先关闭
        [[self HUD] hide:NO];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.labelText = hint;
        HUD.removeFromSuperViewOnHide = YES;
        [view addSubview:HUD];
        [HUD show:YES];
        [self setHUD:HUD];
    });
    
}

- (void)showHudInApp:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [self showHudInView:view hint:hint];
}

- (void)showHint:(NSString *)hint
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //显示提示信息
        UIView *view = [[UIApplication sharedApplication].delegate window];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//        hud.color = [UIColor lightGrayColor];
//        hud.customView.layer.borderColor = [UIColor grayColor].CGColor;
//        hud.customView.layer.borderWidth = 1;
//        hud.labelColor = [UIColor blackColor];
        hud.userInteractionEnabled = NO;
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = hint;
        hud.margin = 10.f;
        //    hud.yOffset = IS_IPHONE_5?50.f:50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    });
    
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //显示提示信息
        UIView *view = [[UIApplication sharedApplication].delegate window];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = hint;
        hud.margin = 10.f;
        hud.yOffset = IS_IPHONE_5?200.f:150.f;
        hud.yOffset += yOffset;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    });
    
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint HowLongClose:(CGFloat) time
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.labelText = hint;
        HUD.removeFromSuperViewOnHide = YES;
        [view addSubview:HUD];
        [HUD show:YES];
        [self setHUD:HUD];
        [HUD hide:YES afterDelay:time];
    });
    
}

- (void)hideHud{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self HUD] hide:YES];
    });
    
}

@end
