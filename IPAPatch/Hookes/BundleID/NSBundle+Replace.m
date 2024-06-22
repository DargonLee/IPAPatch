//
//  NSBundle+Replace.m
//  IPAPatch
//
//  Created by Harlans on 2024/6/22.
//  Copyright © 2024 Weibo. All rights reserved.
//

#import "NSBundle+Replace.h"
#import "JRSwizzle.h"
#import <mach-o/dyld.h>


static NSString *ipaPatch__bundleId = @"";

@implementation NSBundle (Replace)

+ (void)hook
{
    NSError *error = nil;
    [NSBundle jr_swizzleMethod:@selector(infoDictionary) withMethod:@selector(hisInfoDictionary) error:&error];
    if (error) {
        NSLog(@"[IPAPatch][+] hook bundleIdentifier fail");
    }
}

- (NSDictionary<NSString *, id> *)hisInfoDictionary 
{
    NSArray * a = [NSThread callStackSymbols];
    NSArray<NSString *> * ar = [[NSString stringWithUTF8String:_dyld_get_image_name(0)] componentsSeparatedByString:@"/"];
    if (![a[1] containsString:ar.lastObject]) {
        return [self hisInfoDictionary];
    }
    NSMutableDictionary * d = [[NSMutableDictionary alloc] initWithDictionary:[self hisInfoDictionary]];
    d[@"CFBundleIdentifier"] = @"com.jiangjia.gif";
    NSDictionary<NSString *, id> * infoDictionary = [NSDictionary dictionaryWithDictionary:d];
    return infoDictionary;
}

@end
