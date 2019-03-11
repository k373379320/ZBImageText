//
//  ZBImageText.m
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/28.
//  Copyright © 2019 xzb. All rights reserved.
//

#import "ZBImageText.h"

@implementation ZBImageText

- (NSMutableDictionary *)info
{
    if (!_info) {
        _info = [NSMutableDictionary dictionary];
    }
    return _info;
}

@end
@implementation ZBImageTextItemText

- (ZBImageTextItemText * (^)(NSDictionary *config))config
{
    return ^ZBImageTextItemText * (NSDictionary *config) {
        if (config) {
            [self.info addEntriesFromDictionary:[config copy]];
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(UIFont *font))font
{
    return ^ZBImageTextItemText * (UIFont *font) {
        if (font) {
            self.info[@"font"] = font;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(UIFont *baselineFont))baselineFont
{
    return ^ZBImageTextItemText * (UIFont *baselineFont) {
        if (baselineFont) {
            self.info[@"baselineFont"] = baselineFont;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(UIColor *color))color
{
    return ^ZBImageTextItemText * (UIColor *color) {
        if (color) {
            self.info[@"color"] = color;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(ZBImageTextItemBackground *bg))bg
{
    return ^ZBImageTextItemText * (ZBImageTextItemBackground *bg) {
        if (bg.info) {
            self.info[@"bg"] = bg.info;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(ZBImageTextItemBorder *border))border
{
    return ^ZBImageTextItemText * (ZBImageTextItemBorder *border) {
        if (border.info) {
            self.info[@"border"] = border.info;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(CGFloat offset))offset
{
    return ^id (CGFloat offset) {
        self.info[@"offset"] = @(offset);
        return self;
    };
}

@end
@implementation ZBImageTextItemImage

- (ZBImageTextItemImage * (^)(NSDictionary *config))config
{
    return ^ZBImageTextItemImage * (NSDictionary *config) {
        if (config) {
            [self.info addEntriesFromDictionary:[config copy]];
        }
        return self;
    };
}

- (ZBImageTextItemImage * (^)(CGFloat width))width
{
    return ^ZBImageTextItemImage * (CGFloat width) {
        self.info[@"width"] = @(width);
        return self;
    };
}

- (ZBImageTextItemImage * (^)(CGFloat height))height
{
    return ^ZBImageTextItemImage *(CGFloat height) {
        self.info[@"height"] = @(height);
        return self;
    };
}

- (ZBImageTextItemImage * (^)(CGFloat offset))offset
{
    return ^ZBImageTextItemImage * (CGFloat offset) {
        self.info[@"offset"] = @(offset);
        return self;
    };
}

- (ZBImageTextItemImage * (^)(ZBImageTextItemBorder *border))border
{
    return ^ZBImageTextItemImage * (ZBImageTextItemBorder *border) {
        if (border.info) {
            self.info[@"border"] = border.info;
        }
        return self;
    };
}

- (ZBImageTextItemImage * (^)(id url))url
{
    return ^ZBImageTextItemImage * (id url) {
        if (url) {
            self.info[@"url"] = url;
        }
        return self;
    };
}

@end

@implementation ZBImageTextItemBackground

+ (instancetype)bgWithImage:(UIImage *)image margin:(UIEdgeInsets)margin
{
    if (!image) {
        return nil;
    }
    ZBImageTextItemBackground *bg = [[ZBImageTextItemBackground alloc] init];
    bg.info[@"margin"] = [NSValue valueWithUIEdgeInsets:margin];
    bg.info[@"image"] = image;
    return bg;
}

@end

@implementation ZBImageTextItemBorder

+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius
{
    return [self borderWithColor:color width:width radius:radius margin:UIEdgeInsetsZero];
}

+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius margin:(UIEdgeInsets)margin
{
    if (width <= 0) {
        return nil;
    }
    
    ZBImageTextItemBorder *border = [[ZBImageTextItemBorder alloc] init];
    border.info[@"margin"] = [NSValue valueWithUIEdgeInsets:margin];
    border.info[@"color"] = color ? : [UIColor blackColor];
    border.info[@"width"] = @(width);
    border.info[@"radius"] = @(radius);
    return border;
}

@end
