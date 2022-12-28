//
//  UIViewController+Screen.h
//  IPAPatchFramework
//
//  Created by Harlans on 2022/6/1.
//  Copyright © 2022 Weibo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Screen)
@end


@interface UIViewControllerHook : NSObject

+ (void)hook;

@end

@interface UUScreenShieldView : NSObject
+ (void)viewController:(UIViewController *)vc disableScreenshots:(BOOL)isDisable;
@end
NS_ASSUME_NONNULL_END
