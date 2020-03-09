//
//  PingThread.m
//  TestForRunloop
//
//  Created by meitu007 on 2020/2/26.
//  Copyright © 2020 meitu. All rights reserved.
//

#import "PingThread.h"

/**
 由于主线程的runloop在闲置的时候基本处于Before Waiting状态，导致即便没有没有发生任何卡顿，runloop的检测方式会认为主线程处在卡顿状态。
 
 这套监控方案大致思路为: 创建子线程通过信号量去ping主线程，因为ping的时候主线程肯定是在 kCFRunLoopBeforeSources 和 kCFRunLoopAfterWaiting 之间。每次检测时设置标记位为YES，然后派发任务到主线程中将标记位设置为NO。接着子线程沉睡超时阈值时长，判断标志位是否成功设置成NO，如果没有说明主线程发生了卡顿。
 */

@interface PingThread ()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation PingThread

- (void)main {
    [self pingMainThread];
}

- (void)pingMainThread {
    while (!self.cancelled) {
        @autoreleasepool {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.lock unlock];
            });
            
            CFAbsoluteTime pingTime = CFAbsoluteTimeGetCurrent();
//            NSArray *callSymbols = [];
        }
    }
}

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

@end
