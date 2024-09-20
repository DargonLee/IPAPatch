//
//  IPAPatchEntry.m
//  IPAPatch
//
//  Created by wutian on 2017/3/17.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import "IPAPatchEntry.h"
#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import "BundleReplace.h"
#import "NSBundle+Replace.h"

@implementation IPAPatchEntry

+ (void)load
{
    // For Example:
//    [self for_example_showAlert];
    
    /// Show FLEX
//    [self showFLEX];
    
    /// 包名替换
    [BundleReplace hook:@""];
    
}
+ (void)showFLEX
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Class class = NSClassFromString(@"FLEXManager");
        if ([class respondsToSelector:@selector(sharedManager)]) {
            [[class performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
        }
    });
}
+ (void)for_example_showAlert
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
#if TARGET_OS_OSX
        __auto_type alert = [[NSAlert alloc] init];
        alert.messageText = @"Hacked";
        alert.informativeText = @"Hacked with IPAPatch";
        [alert addButtonWithTitle:@"OK"];        
        [alert runModal];
#else
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Hacked" message:@"Hacked with IPAPatch" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL]];
        UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (controller.presentedViewController) {
            controller = controller.presentedViewController;
        }
        [controller presentViewController:alertController animated:YES completion:NULL];
#endif
    });
}

@end
