//
//  JacoHook.m
//  IPAPatch
//
//  Created by Harlans on 2024/9/27.
//  Copyright © 2024 Weibo. All rights reserved.
//

#import "JacoHook.h"
#import "UUCaptainHook.h"
#import "fishhook.h"
#import <dlfcn.h>
#import <sys/sysctl.h>

//int (*ori_sysctl)(int *, u_int, void *, size_t *, void *, size_t);
//int my_sysctl(int *arg1, u_int arg2, void *arg3, size_t *arg4, void *arg5, size_t arg6) {
//    
//    int ret = ori_sysctl(arg1, arg2, arg3, arg4, arg5, arg6);
//    if (arg2 == KERN_PROC && arg3) {
//        struct kinfo_proc *proc_info = arg3;
//        if (proc_info->kp_proc.p_flag & P_TRACED){
//            proc_info->kp_proc.p_flag -= P_TRACED;
//        }
//    }
//    
//    return ret;
//}

CHDeclareClass(AppsFlyerUtils)
CHClassMethod1(BOOL, AppsFlyerUtils, isJailbrokenWithSkipAdvancedJailbreakValidation, BOOL, arg1) {
    BOOL ret = CHSuper1(AppsFlyerUtils, isJailbrokenWithSkipAdvancedJailbreakValidation, arg1);
    return NO;
}

//-[AppsFlyerLib isDebug]
CHDeclareClass(AppsFlyerLib)
CHMethod0(BOOL, AppsFlyerLib, isDebug) {
    return NO;
}

// GULAppEnvironmentUtil
//+ (BOOL) isFromAppStore
CHDeclareClass(GULAppEnvironmentUtil)
CHClassMethod0(BOOL, GULAppEnvironmentUtil, isFromAppStore) {
    return YES;
}

//+[SentrySDK crash]
CHDeclareClass(SentrySDK)
CHClassMethod0(void, SentrySDK, crash) {
    
}

//+[AFSDKChecksum isDevelopmentBuild]
CHDeclareClass(AFSDKChecksum)
CHClassMethod0(BOOL, AFSDKChecksum, isDevelopmentBuild) {
    return NO;
}



@implementation JacoHook

+ (void)hook
{
    CHLoadLateClass(GULAppEnvironmentUtil);
    CHClassHook0(GULAppEnvironmentUtil, isFromAppStore);
    
    CHLoadLateClass(AFSDKChecksum);
    CHClassHook0(AFSDKChecksum, isDevelopmentBuild);
    
    CHLoadLateClass(SentrySDK);
    CHClassHook0(SentrySDK, crash);
    
    CHLoadLateClass(AppsFlyerUtils);
    CHClassHook1(AppsFlyerUtils, isJailbrokenWithSkipAdvancedJailbreakValidation);
    
    CHLoadLateClass(AppsFlyerLib);
    CHHook0(AppsFlyerLib, isDebug);
    
    // rebind_symbols((struct rebinding[1]){{"sysctl", my_sysctl, (void *)&ori_sysctl}}, 1);
}

@end
