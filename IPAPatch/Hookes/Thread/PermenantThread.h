//
//  PermenantThread.h
//  IPAPatch-DummyApp
//
//  Created by Harlans on 2025/3/12.
//  Copyright © 2025 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PermenantTask)(void);

@interface PermenantThread : NSObject
- (void)run;
- (void)stop;
- (void)executeBlock:(PermenantTask)task;
@end

NS_ASSUME_NONNULL_END
