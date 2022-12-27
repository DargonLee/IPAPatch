//
//  BundleReplace.m
//  IPAPatch-DummyApp
//
//  Created by Harlans on 2022/12/27.
//  Copyright © 2022 Weibo. All rights reserved.
//

#import "BundleReplace.h"
#import "HookTools.h"

static NSString *__bundleId = @"xxxx";
static NSString *__groupId = @"xxxx";

@implementation BundleReplace

+ (void)hook:(NSString *)bundleID
{
    __bundleId = [bundleID copy];
    bgl_exchangeMethod([NSBundle class], @selector(bundleIdentifier), [BundleReplace class], @selector(hisBundleID), @selector(bundleIdentifier));
    bgl_exchangeMethod([NSBundle class], @selector(infoDictionary), [BundleReplace class], @selector(hisInfoDictionary), @selector(infoDictionary));
    
//    bgl_exchangeMethod([NSFileManager class], @selector(containerURLForSecurityApplicationGroupIdentifier:), [BundleReplace class], @selector(myContainerURLForSecurityApplicationGroupIdentifier:), @selector(containerURLForSecurityApplicationGroupIdentifier:));
}


- (NSString *)hisBundleID
{
    NSArray * a = [NSThread callStackSymbols];
    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
    if (![a[1] containsString:ar.lastObject]) {
        return [self hisBundleID];
    }
    return __bundleId;
}

- (NSDictionary<NSString *, id> *)hisInfoDictionary {
    NSArray * a = [NSThread callStackSymbols];
    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
    if (![a[1] containsString:ar.lastObject]) {
        return [self hisInfoDictionary];
    }
    NSMutableDictionary * d = [[NSMutableDictionary alloc] initWithDictionary:[self hisInfoDictionary]];
    d[@"CFBundleIdentifier"] = __bundleId;
    NSDictionary<NSString *, id> * infoDictionary = [NSDictionary dictionaryWithDictionary:d];
    return infoDictionary;
}

- (nullable NSURL *)myContainerURLForSecurityApplicationGroupIdentifier:(NSString *)groupIdentifier
{
    NSURL *url = [self myContainerURLForSecurityApplicationGroupIdentifier:__groupId];
    return url;
}

@end
