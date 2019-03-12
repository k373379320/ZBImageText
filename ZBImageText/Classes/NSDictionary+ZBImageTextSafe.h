//
//  NSDictionary+ZBImageTextSafe.h
//  ZBImageText
//
//  Created by xzb on 2019/3/12.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZBImageTextSafe)

- (NSString *)zb_stringValueForKey:(id)key;
- (NSNumber *)zb_numberValueForKey:(id)key;
- (NSUInteger)zb_usingnedIntegerValueForKey:(id)key;
- (NSInteger)zb_integerValueForKey:(id)key;
- (BOOL)zb_boolValueForKey:(id)key;
- (CGFloat)zb_floatValueForKey:(id)key;
- (NSDictionary *)zb_dictValueForKey:(id)key;
- (NSArray *)zb_arrayValueForKey:(id)key;

- (NSString *)zb_safeStringValueForKey:(id)key defaultValue:(NSString *)defaultValue;
- (NSNumber *)zb_safeNumberValueForKey:(id)key defaultValue:(NSNumber *)defaultValue;
- (NSUInteger)zb_safeUnsignedIntegerValueForKey:(id)key defaultValue:(NSUInteger)defaultValue;
- (NSInteger)zb_safeIntegerValueForKey:(id)key defaultValue:(NSInteger)defaultValue;
- (BOOL)zb_safeBoolValueForKey:(id)key defaultValue:(BOOL)defaultValue;
- (CGFloat)zb_safeFloatValueForKey:(id)key defaultValue:(CGFloat)defaultValue;
- (NSArray *)zb_safeArrayValueForKey:(id)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)zb_safeDictionaryValueForKey:(id)key defaultValue:(NSDictionary *)defaultValue;

@end
