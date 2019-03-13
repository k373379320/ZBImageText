//
//  NSDictionary+ZBImageTextSafe.m
//  ZBImageText
//
//  Created by xzb on 2019/3/12.
//

#import "NSDictionary+ZBImageTextSafe.h"
@implementation NSDictionary (ZBImageTextSafe)
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
