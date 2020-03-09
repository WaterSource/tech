//
//  FPSLabel.m
//  TestForRunloop
//
//  Created by meitu007 on 2020/2/26.
//  Copyright © 2020 meitu. All rights reserved.
//

#import "FPSLabel.h"

@interface WeakProxy : NSObject

@property (nonatomic, weak) id target;

@end

@implementation WeakProxy

- (instancetype)initWithTarget:(id)target {
    if (self = [super init]) {
        self.target = target;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL targetRespond = [self.target respondsToSelector:aSelector];
    BOOL superRespond = [super respondsToSelector:aSelector];
    return targetRespond || superRespond;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end

@interface FPSLabel ()

@property (nonatomic, strong) CADisplayLink *link;

// 记录方法执行次数
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation FPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor blackColor];
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        self.link = [CADisplayLink displayLinkWithTarget:[[WeakProxy alloc] initWithTarget:self] selector:@selector(tick:)];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc {
    [self.link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    if (self.lastTime == 0) {
        self.lastTime = self.link.timestamp;
    } else {
        self.count ++;
        NSTimeInterval timePassed = link.timestamp - self.lastTime;
        
        if (timePassed >= 1) {
            self.lastTime = link.timestamp;
            CGFloat fps = self.count / timePassed;
            self.count = 0;
            
            CGFloat progress = fps / 60.0;
            self.text = [NSString stringWithFormat:@"%.1f FPS", fps];
        }
    }
}

@end
