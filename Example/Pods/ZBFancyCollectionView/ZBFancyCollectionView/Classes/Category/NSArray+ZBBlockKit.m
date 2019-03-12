//
//  NSArray+ZBBlockKit.m
//  ZBFancyCollectionView
//
//  Created by xzb on 2018/8/1.
//

#import "NSArray+ZBBlockKit.h"


extern CGSize ZBGetSizeSendMsg(id target, SEL selector, id model)
{
    CGSize size;
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"{CGSize=dd}#:@"];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    inv.target = target;
    inv.selector = selector;
    [inv setArgument:&model atIndex:2];
    [inv invoke];
    [inv getReturnValue:&size];
    return size;
}

extern UIEdgeInsets ZBGetEdgeInsetsSendMsg(id target, SEL selector, id model)
{
    UIEdgeInsets insets;
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"{UIEdgeInsets=dddd}#:@"];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    inv.target = target;
    inv.selector = selector;
    [inv setArgument:&model atIndex:2];
    [inv invoke];
    [inv getReturnValue:&insets];
    return insets;
}


@implementation NSArray (ZBBlockKit)

- (void)zbbk_each:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (NSArray *)zbbk_map:(id (^)(id obj))block
{
    NSParameterAssert(block != nil);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
    }];
    
    return result;
}

@end
