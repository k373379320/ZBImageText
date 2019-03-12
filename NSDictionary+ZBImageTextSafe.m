//
//  NSDictionary+ZBImageTextSafe.m
//  ZBImageText
//
//  Created by xzb on 2019/3/12.
//

#import "NSDictionary+ZBImageTextSafe.h"

@implementation NSDictionary (ZBImageTextSafe)

- (NSString *)zb_stringValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeStringValueForKey:key defaultValue:nil];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
#endif
}

- (NSNumber *)zb_numberValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeNumberValueForKey:key defaultValue:nil];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
#endif
}

- (NSDictionary *)zb_dictValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeDictionaryValueForKey:key defaultValue:nil];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
#endif
}

- (NSArray *)zb_arrayValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeArrayValueForKey:key defaultValue:nil];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
#endif
}

- (NSUInteger)zb_usingnedIntegerValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeUnsignedIntegerValueForKey:key defaultValue:0];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
#endif
}

- (NSInteger)zb_integerValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeIntegerValueForKey:key defaultValue:0];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
#endif
}

- (BOOL)zb_boolValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeBoolValueForKey:key defaultValue:NO];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
#endif
}

- (CGFloat)zb_floatValueForKey:(id)key;
{
#ifndef DEBUG
    return [self zb_safeFloatValueForKey:key defaultValue:NO];
#else
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0;
#endif
}

- (NSString *)zb_safeStringValueForKey:(id)key defaultValue:(NSString *)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else {
        return [NSString stringWithFormat:@"%@", value];
    }
}
- (NSNumber *)zb_safeNumberValueForKey:(id)key defaultValue:(NSNumber *)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSString class]]) {
        return @([value doubleValue]);
    } else {
        return defaultValue;
    }
}

- (NSUInteger)zb_safeUnsignedIntegerValueForKey:(id)key defaultValue:(NSUInteger)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return (NSUInteger)[value integerValue];
    } else {
        return defaultValue;
    }
}
- (NSInteger)zb_safeIntegerValueForKey:(id)key defaultValue:(NSInteger)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    } else {
        return defaultValue;
    }
}

- (BOOL)zb_safeBoolValueForKey:(id)key defaultValue:(BOOL)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    } else {
        return defaultValue;
    }
}

- (CGFloat)zb_safeFloatValueForKey:(id)key defaultValue:(CGFloat)defaultValue;
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    } else {
        return defaultValue;
    }
}

- (NSArray *)zb_safeArrayValueForKey:(id)key defaultValue:(NSArray *)defaultValue
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

- (NSDictionary *)zb_safeDictionaryValueForKey:(id)key defaultValue:(NSDictionary *)defaultValue
{
    id value = self[key];
    if (value == nil) {
        return defaultValue;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

@end
