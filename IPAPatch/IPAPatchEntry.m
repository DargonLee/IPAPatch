//
//  IPAPatchEntry.m
//  IPAPatch
//
//  Created by wutian on 2017/3/17.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import "IPAPatchEntry.h"
#import "HookTools.h"

#import "PermissionCheck.h"
#import "BundleReplace.h"

#define BUNDLEID @"xxxxxxx"

@implementation IPAPatchEntry

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 使用passHTTPS3时请不要调用显示FLEX，FLEX抓端口的原理跟passHTTPS3的原理一样，因此代码会出现冲突（NSURLProtocol只能存在一个）。
//        [HookTools showFLEXDelayBy:5];
        
        // 可以检测网络请求中出现的敏感数据，规则自己去HookURLProtocol.m里写
        [NSURLProtocol registerClass:[NSClassFromString(@"HookURLProtocol") class]];

        // 开始检测权限使用
//        [PermissionCheck hook];
        
        // 替换bundleID
        [BundleReplace hook:BUNDLEID];
    });
}

@end
