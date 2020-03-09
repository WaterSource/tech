//
//  RunloopDetective.m
//  TestForRunloop
//
//  Created by meitu007 on 2020/2/25.
//  Copyright © 2020 meitu. All rights reserved.
//

#import "RunloopDetective.h"

/**
 因为runloop的方法调用主要集中在 beforeSources(判断是否有source0事件) 和 afterWaiting(结束休眠) 之间。
 区间选择的原因: source0 就是主要处理App的内部事件，也就是大部分导致卡顿的方法。
 新建一个子线程，在子线程计算区间内的耗时是否超过了某个具体的阈值，用于判断主线程的卡顿情况。
 */

@interface RunloopDetective ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@end

@implementation RunloopDetective

+ (instancetype)sharedInstance {
    static RunloopDetective *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunloopDetective *detective = (__bridge RunloopDetective *)info;
    detective->activity = activity;
    
    dispatch_semaphore_t semaphore = detective->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)stop {
    if (!observer) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)start {
    
    if (observer) {
        return;
    }
    
    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    
    
    // allocator: 用于给新对象分配空间
    // activities: 设置runloop运行阶段的标志，运行到此阶段时，CFRunLoopObserver会被调用
    // repeats: CFRunLoopObserver是否循环调用
    // order: Observer的优先级
    // callout
    // context: 传递进callout的内容
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    
    // 添加一个observer到runloop mode中
    CFRunLoopAddObserver(CFRunLoopGetMain(),
                         observer,
                         kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {
                if (!self->observer) {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return ;
                }
                
                if (self->activity == kCFRunLoopBeforeSources ||
                    self->activity == kCFRunLoopAfterWaiting) {
                    
                    self->timeoutCount ++;
                    
                    if (self->timeoutCount < 5) {
                        continue;
                    }
                    
                    // 方案一: 连续5次超时50ms
                    // 方案二: 连续3次超过80ms
                    
                    NSLog(@"RunloopDetective find some ");
                }
            }
            
            self->timeoutCount = 0;
        }
    });
}

- (void)useless {
    CFRunLoopActivity act = kCFRunLoopEntry;
    switch (act) {
        case kCFRunLoopEntry:
        case kCFRunLoopBeforeTimers:
        case kCFRunLoopBeforeSources:
        case kCFRunLoopBeforeWaiting:
        case kCFRunLoopAfterWaiting:
        case kCFRunLoopExit:
        case kCFRunLoopAllActivities:
        default:
            break;
    }
}

@end
