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
static NSMutableDictionary *ipaPatch__glb__realyInfo = nil;

@implementation NSObject (Info)
+ (NSDictionary *)his_dictionaryWithContentsOfFile:(NSString *)path
{
    NSDictionary *info = [self his_dictionaryWithContentsOfFile:path];
    if ([path hasSuffix:@"Info.plist"]) {
        NSMutableDictionary *realyInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        realyInfo[@"CFBundleIdentifier"] = ipaPatch__bundleId;
        return realyInfo;
    }
    return info;
}
@end
@implementation NSBundle (Info)
static NSDictionary *dic;
- (NSDictionary*)his_infoDictionary
{
    NSDictionary *originalInfoDictionary = [self his_infoDictionary];
    if(!ipaPatch__glb__realyInfo) {
        ipaPatch__glb__realyInfo = [NSMutableDictionary dictionaryWithDictionary:originalInfoDictionary];
    }
    ipaPatch__glb__realyInfo[@"CFBundleIdentifier"] = ipaPatch__bundleId;
    dic = (__bridge NSDictionary *)((__bridge CFDictionaryRef)ipaPatch__glb__realyInfo);
    return dic;
}
@end

@implementation BundleReplace

+ (void)hook:(NSString *)bundleID
{
    ipaPatch__bundleId = [bundleID copy];
    
    NSError *error = nil;
    [NSDictionary jr_swizzleClassMethod:@selector(dictionaryWithContentsOfFile:) withClassMethod:@selector(his_dictionaryWithContentsOfFile:) error:&error];
    if (error) {
        NSLog(@"[NSDictionary dictionaryWithContentsOfFile:] %s, %@", __FUNCTION__, error);
    }
    [NSBundle jr_swizzleMethod:@selector(infoDictionary) withMethod:@selector(his_infoDictionary) error:&error];
    if (error) {
        NSLog(@"[NSBundle infoDictionary] %s, %@", __FUNCTION__, error);
    }
}

@end
