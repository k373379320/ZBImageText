//
//  ZBImageText.h
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/28.
//  Copyright © 2019 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBImageTextMaker;

@class ZBImageTextItemBackground, ZBImageTextItemBorder, ZBImageTextItemDecoration;

typedef void (^YYTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);

@interface ZBImageText : NSObject

@property (nonatomic, strong) NSMutableDictionary *info;

@end

@interface ZBImageTextItemText : ZBImageText

@property (nonatomic, copy) ZBImageTextItemText * (^ config)(NSDictionary *config);

@property (nonatomic, copy) ZBImageTextItemText * (^ font)(UIFont *font);

@property (nonatomic, copy) ZBImageTextItemText * (^ baselineFont)(UIFont *baselineFont);

@property (nonatomic, copy) ZBImageTextItemText * (^ color)(UIColor *color);

@property (nonatomic, copy) ZBImageTextItemText * (^ offset)(CGFloat offset);

@property (nonatomic, copy) ZBImageTextItemText * (^ bg)(ZBImageTextItemBackground *bg);

@property (nonatomic, copy) ZBImageTextItemText * (^ border)(ZBImageTextItemBorder *border);

@property (nonatomic, copy) ZBImageTextItemText * (^ tap)(YYTextAction action);

@property (nonatomic, copy) ZBImageTextItemText * (^ decoration)(ZBImageTextItemDecoration *decoration);

@end

@interface ZBImageTextItemImage : ZBImageText

@property (nonatomic, copy) ZBImageTextItemImage * (^ config)(NSDictionary *config);

@property (nonatomic, copy) ZBImageTextItemImage * (^ width)(CGFloat width);

@property (nonatomic, copy) ZBImageTextItemImage * (^ height)(CGFloat height);

@property (nonatomic, copy) ZBImageTextItemImage * (^ size)(CGSize size);

@property (nonatomic, copy) ZBImageTextItemImage * (^ offset)(CGFloat offset);

@property (nonatomic, copy) ZBImageTextItemImage * (^ border)(ZBImageTextItemBorder *border);

@property (nonatomic, copy) ZBImageTextItemImage * (^ url)(id url);

@property (nonatomic, copy) ZBImageTextItemImage * (^ tap)(YYTextAction action);

@end

@interface ZBImageTextItemBackground : ZBImageText

+ (instancetype)bgWithImage:(UIImage *)image margin:(UIEdgeInsets)margin;

+ (instancetype)bgWithImage:(UIImage *)image margin:(UIEdgeInsets)margin stretchable:(BOOL)stretchable;

@end

@interface ZBImageTextItemBorder : ZBImageText

+ (instancetype)borderWithRadius:(CGFloat)radius;

+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;

+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius margin:(UIEdgeInsets)margin;

@end

@interface ZBImageTextItemDecoration : ZBImageText

/**
 删除线,与字体颜色一致
 */
+ (instancetype)decoration;

/**
 删除线,自定义高度,颜色,
 */
+ (instancetype)decorationWithHeight:(CGFloat)height color:(UIColor *)color;

/**
 删除线,自定义高度,颜色,偏移位置
 */
+ (instancetype)decorationWithHeight:(CGFloat)height color:(UIColor *)color offset:(CGFloat)offset;

@end
