//
//  PermenantThread.m
//  IPAPatch-DummyApp
//
//  Created by Harlans on 2025/3/12.
//  Copyright © 2025 Weibo. All rights reserved.
//

#import "PermenantThread.h"

@interface HLThread : NSThread
@end
@implementation HLThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

@interface PermenantThread()
@property (nonatomic, strong) HLThread *thread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;
@end

@implementation PermenantThread

- (instancetype)init
{
    if (self = [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.thread = [[HLThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
            }
            NSLog(@"Runloop stop");
        }];
    }
    return self;
}

- (void)run
{
    if (!self.thread) {
        return;
    }
    [self.thread start];
}

- (void)stop
{
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)executeBlock:(PermenantTask)task
{
    if (!self.thread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)__stop
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)__executeTask:(PermenantTask)task
{
    task();
}


@end
