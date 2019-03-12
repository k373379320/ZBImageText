//
//  ZBFpsTool.m
//  ZBUitilty
//
//  Created by xzb on 2018/12/25.
//

#import "ZBFpsTool.h"
#define ZB_SINGLETON_INSTANCE_METHOD_DECLARATION +(instancetype)instance;

#define ZB_SINGLETON_INSTANCE_METHOD_IMPLEMENTATION \
+ (instancetype)instance                        \
{                                               \
static dispatch_once_t oncePredicate;       \
static id instance;                         \
dispatch_once(&oncePredicate, ^{            \
instance = [[self alloc] init];           \
});                                         \
return instance;                            \
}

@interface ZBFpsTool ()

{
    CADisplayLink *_displayLink;
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

@property(nonatomic,copy) void (^fpsHandler)(NSInteger fpsValue);

@end


@implementation ZBFpsTool

ZB_SINGLETON_INSTANCE_METHOD_IMPLEMENTATION

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];        
    }
    return self;
}

- (void)dealloc
{
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    _count++;
    NSTimeInterval interval = link.timestamp - _lastTime;
    if (interval < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / interval;
    _count = 0;
    if (_fpsHandler) {
        _fpsHandler((int)round(fps));
    }
}

- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler
{
    [self open];
    _fpsHandler=handler;
}

- (void)open
{
    [_displayLink setPaused:NO];
}

- (void)close
{
    [_displayLink setPaused:YES];
}

- (void)applicationDidBecomeActiveNotification
{
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification
{
    [_displayLink setPaused:YES];
}

@end
