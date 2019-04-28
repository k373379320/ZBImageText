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

- (ZBImageTextItemText * (^)(YYTextAction action))tap
{
    return ^ZBImageTextItemText * (YYTextAction action) {
        if (action) {
            self.info[@"tap"] = action;
        }
        return self;
    };
}

- (ZBImageTextItemText * (^)(ZBImageTextItemDecoration *decoration))decoration
{
    return ^ZBImageTextItemText * (ZBImageTextItemDecoration *decoration) {
        if (decoration.info) {
            self.info[@"decoration"] = decoration.info;
        }
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

- (ZBImageTextItemImage * (^)(CGSize size))size
{
    return ^ZBImageTextItemImage *(CGSize size) {
        self.info[@"width"] = @(size.width);
        self.info[@"height"] = @(size.height);
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

- (ZBImageTextItemImage * (^)(YYTextAction action))tap
{
    return ^ZBImageTextItemImage * (YYTextAction action) {
        if (action) {
            self.info[@"tap"] = action;
        }
        return self;
    };
}

@end

@implementation ZBImageTextItemBackground

+ (instancetype)bgWithImage:(UIImage *)image margin:(UIEdgeInsets)margin
{
    return [self bgWithImage:image margin:margin stretchable:YES];
}

+ (instancetype)bgWithImage:(UIImage *)image margin:(UIEdgeInsets)margin stretchable:(BOOL)stretchable
{
    if (!image) {
        return nil;
    }
    ZBImageTextItemBackground *bg = [[ZBImageTextItemBackground alloc] init];
    bg.info[@"margin"] = [NSValue valueWithUIEdgeInsets:margin];
    bg.info[@"image"] = image;
    bg.info[@"stretchable"] = @(stretchable);
    return bg;
}

@end

@implementation ZBImageTextItemBorder

+ (instancetype)borderWithRadius:(CGFloat)radius
{
    return [self borderWithColor:nil width:0 radius:radius margin:UIEdgeInsetsZero];
}


+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius
{
    return [self borderWithColor:color width:width radius:radius margin:UIEdgeInsetsZero];
}

+ (instancetype)borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius margin:(UIEdgeInsets)margin
{
    ZBImageTextItemBorder *border = [[ZBImageTextItemBorder alloc] init];
    border.info[@"margin"] = [NSValue valueWithUIEdgeInsets:margin];
    if (color) {
        border.info[@"color"] = color;
    }
    if (width > 0) {
        border.info[@"width"] = @(width);
    }
    if (radius > 0) {
        border.info[@"radius"] = @(radius);
    }
    return border;
}

@end
@implementation ZBImageTextItemDecoration

+ (instancetype)decoration
{
    return [self decorationWithHeight:0 color:nil offset:0];
}

+ (instancetype)decorationWithHeight:(CGFloat)height color:(UIColor *)color
{
     return [self decorationWithHeight:height color:color offset:0];
}

+ (instancetype)decorationWithHeight:(CGFloat)height color:(UIColor *)color offset:(CGFloat)offset
{
    ZBImageTextItemDecoration *decoration = [[ZBImageTextItemDecoration alloc] init];
    if (color) {
        decoration.info[@"color"] = color;
    }
    if (height > 0) {
        decoration.info[@"height"] = @(height);
    }
    if (offset > 0) {
        decoration.info[@"offset"] = @(offset);
    }
    return decoration;
}

@end
