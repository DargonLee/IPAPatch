//
//  BundleReplace.h
//  IPAPatch-DummyApp
//
//  Created by Harlans on 2022/12/27.
//  Copyright © 2022 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BundleReplace : NSObject

+ (void)hook:(NSString *)bundleID;

@end

NS_ASSUME_NONNULL_END
