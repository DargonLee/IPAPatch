//
//  BundleReplace.m
//  IPAPatch-DummyApp
//
//  Created by Harlans on 2022/12/27.
//  Copyright © 2022 Weibo. All rights reserved.
//

#import "BundleReplace.h"
#import "HookTools.h"
#import "UUCaptainHook.h"
#import "JRSwizzle.h"

static NSString *ipaPatch__bundleId = @"";
static NSString *ipaPatch__groupId = @"xxxx";

@implementation BundleReplace

+ (void)hook:(NSString *)bundleID
{
    ipaPatch__bundleId = [bundleID copy];
    
//    bgl_exchangeMethod([NSBundle class], @selector(bundleIdentifier), [BundleReplace class], @selector(hisBundleID), @selector(bundleIdentifier));
    bgl_exchangeMethod([NSBundle class], @selector(infoDictionary), [BundleReplace class], @selector(hisInfoDictionary), @selector(infoDictionary));
//    bgl_exchangeMethod([NSFileManager class], @selector(containerURLForSecurityApplicationGroupIdentifier:), [BundleReplace class], @selector(myContainerURLForSecurityApplicationGroupIdentifier:), @selector(containerURLForSecurityApplicationGroupIdentifier:));
    
}

- (NSString *)hisBundleID
{
    NSLog(@"[IPAPatch][+] hisBundleID");
    NSArray * a = [NSThread callStackSymbols];
    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
//    if (![a[1] containsString:ar.lastObject]) {
//        NSString *orig = [self hisBundleID];
//        orig = [orig stringByReplacingOccurrencesOfString:@".app1" withString:@""];
//        return orig;
//    }
    NSString *executableName = ar.firstObject;
    for (NSString *symbol in a) {
        if (![symbol containsString:executableName]) {
            NSString *orig = [self hisBundleID];
            NSLog(@"old bundle id : %@", orig);
            NSMutableArray *array = [orig componentsSeparatedByString:@"."].mutableCopy;
            [array removeLastObject];
            orig = [array componentsJoinedByString:@"."];
            NSLog(@"new bundle id : %@", orig);
            return orig;
        }
    }
    return ipaPatch__bundleId;
}

- (NSDictionary<NSString *, id> *)hisInfoDictionary {
    NSArray * a = [NSThread callStackSymbols];
    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
    if (![a[1] containsString:ar.lastObject]) {
        return [self hisInfoDictionary];
    }
    NSMutableDictionary * d = [[NSMutableDictionary alloc] initWithDictionary:[self hisInfoDictionary]];
    d[@"CFBundleIdentifier"] = ipaPatch__bundleId;
    NSDictionary<NSString *, id> * infoDictionary = [NSDictionary dictionaryWithDictionary:d];
    return infoDictionary;
}

//- (NSDictionary<NSString *, id> *)hisInfoDictionary {
//    NSArray * a = [NSThread callStackSymbols];
//    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
//    if (![a[1] containsString:ar.lastObject]) {
//        return [self hisInfoDictionary];
//    }
//    NSMutableDictionary * d = [[NSMutableDictionary alloc] initWithDictionary:[self hisInfoDictionary]];
//    d[@"CFBundleIdentifier"] = ipaPatch__bundleId;
//    NSDictionary<NSString *, id> * infoDictionary = [NSDictionary dictionaryWithDictionary:d];
//    return infoDictionary;
//}

- (nullable NSURL *)myContainerURLForSecurityApplicationGroupIdentifier:(NSString *)groupIdentifier
{
    NSURL *url = [self myContainerURLForSecurityApplicationGroupIdentifier:ipaPatch__groupId];
    return url;
}

@end
