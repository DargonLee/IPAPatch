//
//  UIViewController+Screen.m
//  IPAPatchFramework
//
//  Created by Harlans on 2022/6/1.
//  Copyright © 2022 Weibo. All rights reserved.
//

#import "UIViewController+Screen.h"
#import "HookTools.h"

@implementation UIViewController (Screen)



@end

@implementation UIViewControllerHook

+ (void)hook
{
    bgl_exchangeMethod([UIViewController class], @selector(viewDidLoad), [UIViewControllerHook class], @selector(uu_viewDidLoad), @selector(viewDidLoad));
}

- (void)uu_viewDidLoad
{
    NSLog(@"uu_viewDidLoad");
    [UUScreenShieldView viewController:self disableScreenshots:YES];
    [self uu_viewDidLoad];
}

@end


@implementation UUScreenShieldView

+ (void)viewController:(UIViewController *)vc disableScreenshots:(BOOL)isDisable
{
    if (isDisable) {
        UIView *rootView = [self getTextLayoutCanvasViewWithFrame:UIScreen.mainScreen.bounds];
        // 把Vc上的父View添加到rootView
        [rootView addSubview:vc.view];
        // 再把添加好的rootView重新复制给Vc的View
        vc.view = rootView;
    }
}
+ (UIView *)getTextLayoutCanvasViewWithFrame:(CGRect)frame
{
    UIView *rootView = nil;
    
    UITextField *root = [[UITextField alloc] initWithFrame:frame];
    if(root){
        root.secureTextEntry=YES;//利用密码框录屏不可见的特性
        UIView *textLayoutCanvasView=root.subviews.firstObject;//获取_UITextLayoutCanvasView
        if (textLayoutCanvasView.subviews.count) {
            [textLayoutCanvasView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        textLayoutCanvasView.frame = UIScreen.mainScreen.bounds;
        textLayoutCanvasView.userInteractionEnabled=YES;
        textLayoutCanvasView.backgroundColor=[UIColor whiteColor];
        rootView = textLayoutCanvasView;
    }else {
        rootView = root.subviews.firstObject;
        rootView.backgroundColor = [UIColor whiteColor];
    }
    return rootView;
}

@end
