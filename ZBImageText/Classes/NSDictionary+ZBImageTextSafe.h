//
//  NSDictionary+ZBImageTextSafe.h
//  ZBImageText
//
//  Created by xzb on 2019/3/12.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZBImageTextSafe)

- (NSString *)zb_safeStringValueForKey:(id)key defaultValue:(NSString *)defaultValue;
- (NSNumber *)zb_safeNumberValueForKey:(id)key defaultValue:(NSNumber *)defaultValue;
- (NSUInteger)zb_safeUnsignedIntegerValueForKey:(id)key defaultValue:(NSUInteger)defaultValue;
- (NSInteger)zb_safeIntegerValueForKey:(id)key defaultValue:(NSInteger)defaultValue;
- (BOOL)zb_safeBoolValueForKey:(id)key defaultValue:(BOOL)defaultValue;
- (CGFloat)zb_safeFloatValueForKey:(id)key defaultValue:(CGFloat)defaultValue;
- (NSArray *)zb_safeArrayValueForKey:(id)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)zb_safeDictionaryValueForKey:(id)key defaultValue:(NSDictionary *)defaultValue;
- (UIFont *)zb_safeFontValueForKey:(id)key defaultValue:(UIFont *)defaultValue;
- (UIColor *)zb_safeColorValueForKey:(id)key defaultValue:(UIColor *)defaultValue;
- (UIImage *)zb_safeImageValueForKey:(id)key defaultValue:(UIImage *)defaultValue;

@end
