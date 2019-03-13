//
//  ZBImageTextUtility.m
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/27.
//  Copyright © 2019 xzb. All rights reserved.
//

#import "ZBImageTextEngine.h"
#import <YYText/YYText.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDictionary+ZBImageTextSafe.h"

typedef void (^ZBImageTextBlock)(id obj);

#ifdef DEBUG
#define kStartTime //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#define kEnd(__log__) //CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime); NSLog(@"📝--%@-->  %f ms", __log__, linkTime * 1000.0);
#else
#define kStartTime
#define kEnd(__log__)
#endif

@interface ZBImageTextItem : NSObject

@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, assign) CGSize size;

@end

@implementation ZBImageTextItem

@end

@interface ZBImageTextEngine ()

@end

@implementation ZBImageTextEngine

+ (NSArray<NSString *> *)templates
{
    return @[@"text", @"image", @"space"];
}

#pragma mark - api
+ (NSAttributedString *)attributedStringFromData:(NSArray *)data
{
    kStartTime;
    NSArray<NSDictionary *> *items = [self filterData:data];
    {
        kEnd(@"过滤数据耗时");
    }
    if (items.count == 0) {
        return nil;
    }
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *itemData in items) {
        NSAttributedString *itemAtr = [self itemAttributedStringFromItemData:itemData];
        if (itemAtr) {
            kStartTime;
            [atr appendAttributedString:itemAtr];
#ifdef DEBUG
            NSString *desc = [NSString stringWithFormat:@"生成template:%@", itemData[@"template"]];
            kEnd(desc);
#endif
        }
    }
    kEnd(@"生成attributed总耗时");
    return [atr copy];
}

#pragma mark - prive

+ (NSString *)templateNameForData:(NSDictionary *)itemData
{
    if (!itemData) {
        return @"";
    }
    for (NSString *key in itemData.allKeys) {
        if ([[self templates] containsObject:key]) {
            return key;
        }
    }
    return @"";
}

+ (NSAttributedString *)itemAttributedStringFromItemData:(NSDictionary *)data
{
    if ([data[@"template"] isEqualToString:@"space"]) {
        return [self spaceTemplateWithData:data].attributedString;
    }
    if ([data[@"template"] isEqualToString:@"image"]) {
        return [self imageTemplateWithData:data].attributedString;
    }
    if ([data[@"template"] isEqualToString:@"text"]) {
        return [self textTemplateWithData:data].attributedString;
    }
    return nil;
}

+ (NSArray<NSDictionary *> *)filterData:(NSArray *)data
{
    if (![data isKindOfClass:[NSArray class]]) {
        return @[];
    }
    NSMutableArray<NSDictionary *> *result = [NSMutableArray arrayWithCapacity:data.count];
    for (id obj in data) {
        NSDictionary *item;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            item = obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            item = @{
                     @"space" : obj
                     };
        }
        //确认模板
        NSString *templateName = [self templateNameForData:item];
        if (templateName.length > 0) {
            NSMutableDictionary *resultDict = item.mutableCopy;
            resultDict[@"template"] = templateName;
            [result addObject:resultDict];
        }
    }
    return result;
}

#pragma mark - template
+ (ZBImageTextItem *)spaceTemplateWithData:(NSDictionary *)data
{
    CGFloat space = [data zb_safeFloatValueForKey:@"space" defaultValue:0];
    if (space <= 0) {
        return nil;
    }
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = space;
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    ZBImageTextItem *item = [[ZBImageTextItem alloc] init];
    item.attributedString = [atr copy];
    item.size = CGSizeMake(space, 0);
    return item;
}

+ (ZBImageTextItem *)imageTemplateWithData:(NSDictionary *)data
{
    NSURL *imageURL = imageURL = [NSURL URLWithString:[data zb_safeStringValueForKey:@"url" defaultValue:@""]];
    UIImage *image = data[@"image"];
    
    if (![image isKindOfClass:[UIImage class]] || CGSizeEqualToSize(image.size, CGSizeZero)) {
        return nil;
    }
    //hook
    ZBImageTextBlock imageViewBlock = data[@"imageView"] ? : nil;
    ZBImageTextBlock itemBlock = data[@"item"] ? : nil;
    
    //action
    YYTextAction tapAction = data[@"tap"] ? : nil;
    
    CGFloat width = [data zb_safeFloatValueForKey:@"width" defaultValue:image.size.width];
    CGFloat height = [data zb_safeFloatValueForKey:@"height" defaultValue:image.size.height];
    NSDictionary *border = [data zb_safeDictionaryValueForKey:@"border" defaultValue:nil];
    CGFloat offset = [data zb_safeFloatValueForKey:@"offset" defaultValue:0];
    
    CGSize containerSize = CGSizeMake(width, height);
    
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, containerSize.width, containerSize.height)];
        if (imageURL) {
            [imageV sd_setImageWithURL:imageURL placeholderImage:image completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                CALayer *superLayer = containerLayer.superlayer;
                if (superLayer && [superLayer.delegate isKindOfClass:[YYLabel class]]) {
                    imageV.layer.contents = (id)image.CGImage;
                    YYLabel *label = (YYLabel *)superLayer.delegate;
                    [label setNeedsLayout];
                }
            }];
        } else {
            imageV.image = image;
        }
        if (border) {
            UIColor *color = border[@"color"] ? border[@"color"] : [UIColor blackColor];
            CGFloat width = [border zb_safeFloatValueForKey:@"width" defaultValue:0.5];
            CGFloat radius = [border zb_safeFloatValueForKey:@"radius" defaultValue:0];
            if (width > 0) {
                imageV.layer.borderColor = color.CGColor;
                imageV.layer.borderWidth = width;
            }
            if (radius > 0) {
                imageV.layer.cornerRadius = radius;
            }
        }
        if (imageViewBlock) {
            imageViewBlock(imageV);
        }
        [containerLayer addSublayer:imageV.layer];
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    if (tapAction) {
        [atr yy_setTextHighlightRange:NSMakeRange(0, YYTextAttachmentToken.length) color:[UIColor clearColor] backgroundColor:[UIColor clearColor] tapAction:tapAction];
    }
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = containerLayer;
    attach.contentMode = YYTextVerticalAlignmentCenter;
    [atr yy_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width =  containerSize.width;
    delegate.ascent =  containerSize.height;
    delegate.descent = 0;
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    ZBImageTextItem *item = [[ZBImageTextItem alloc] init];
    item.attributedString = [atr copy];
    item.size = containerSize;
    if (itemBlock) {
        itemBlock(item);
    }
    return item;
}

+ (ZBImageTextItem *)textTemplateWithData:(NSDictionary *)data
{
    NSString *text = [data zb_safeStringValueForKey:@"text" defaultValue:@""];
    if (text.length <= 0) {
        return nil;
    }
    UIFont *font = data[@"font"] ? data[@"font"] : [UIFont systemFontOfSize:15];
    UIColor *color =  data[@"color"] ? data[@"color"] : [UIColor blackColor];
    
    //对齐
    UIFont *baselineFont = data[@"baselineFont"] ? data[@"baselineFont"] : nil;
    //边框
    UIEdgeInsets borderMargin;
    UIColor *borderColor = [UIColor blackColor];
    CGFloat borderWidth = 0.5f;
    CGFloat borderRadius = 0;
    NSDictionary *border = [data zb_safeDictionaryValueForKey:@"border" defaultValue:nil];
    if (border) {
        borderMargin = border[@"margin"] ? [border[@"margin"] UIEdgeInsetsValue] : UIEdgeInsetsZero;
        borderColor = border[@"color"] ? border[@"color"] : [UIColor blackColor];
        borderWidth = [border zb_safeFloatValueForKey:@"width" defaultValue:0.5];
        borderRadius = [border zb_safeFloatValueForKey:@"radius" defaultValue:0.5];
    }
    
    //垂直偏移
    CGFloat offset = [data zb_safeFloatValueForKey:@"offset" defaultValue:0];
    
    //bg
    NSDictionary *bg = [data zb_safeDictionaryValueForKey:@"bg" defaultValue:nil];
    BOOL bgImageStretchable = [bg zb_safeBoolValueForKey:@"stretchable" defaultValue:YES];
    UIImage *bgImage = bg[@"image"] ? bg[@"image"] : nil;
    if (bgImage) {
        if (bg[@"margin"]) {
            borderMargin = [bg[@"margin"] UIEdgeInsetsValue];
        }
    }
    NSDictionary *textDecoration = [data zb_safeDictionaryValueForKey:@"decoration" defaultValue:nil];
    //hook
    ZBImageTextBlock imageViewBlock = data[@"imageView"] ? : nil;
    ZBImageTextBlock itemBlock = data[@"item"] ? : nil;
    ZBImageTextBlock textLayerBlock = data[@"textLayer"] ? : nil;
    
    //action
    YYTextAction tapAction = data[@"tap"] ? : nil;
    
    CGSize containerSize = [text sizeWithAttributes:@{
                                                      NSFontAttributeName : font
                                                      }];
    
    containerSize = CGSizeMake(containerSize.width + borderMargin.left + borderMargin.right, containerSize.height +  borderMargin.top + borderMargin.bottom);
    
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    
    if (border) {
        //不能直接在containerLayer 上绘制,会导致offset无法实现;
        CALayer *borderLayer = [CALayer layer];
        
        borderLayer.borderColor = borderColor.CGColor;
        borderLayer.borderWidth = borderWidth;
        if (borderRadius > 0) {
            borderLayer.cornerRadius = borderRadius;
        }
        [containerLayer addSublayer:borderLayer];
        borderLayer.frame = CGRectMake(0, offset, containerSize.width, containerSize.height);
    }
    if (bgImage) {
        if (bgImageStretchable) {
            bgImage = [UIImage imageWithCGImage:bgImage.CGImage scale:[UIScreen mainScreen].scale orientation:bgImage.imageOrientation];
            bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width * 0.5 topCapHeight:bgImage.size.height * 0.5];
        }
        
        //CALayer实现不了stretchable
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, containerSize.width, containerSize.height)];
        imageV.image = bgImage;
        if (imageViewBlock) {
            imageViewBlock(imageV);
        }
        [containerLayer addSublayer:imageV.layer];
    }
    NSMutableAttributedString *textAttributedString;
    {
        textAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
        textAttributedString.yy_font = font;
        textAttributedString.yy_color = color;
        textAttributedString.yy_lineSpacing = 0;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = (id)[textAttributedString copy];
        //如果不设置这个,字数太多"..."颜色不对
        textLayer.foregroundColor = color.CGColor;
        textLayer.fontSize = font.pointSize;
        //自动换行
        textLayer.wrapped = NO;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.truncationMode = kCATruncationEnd;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = CGRectMake(borderMargin.left, borderMargin.top + offset, containerSize.width - (borderMargin.left + borderMargin.right), containerSize.height - (borderMargin.top + borderMargin.bottom));
        if (textLayerBlock) {
            textLayerBlock(textLayer);
        }
        if (textDecoration) {
            UIColor *decorationColor = textDecoration[@"color"] ? textDecoration[@"color"] : color;
            CGFloat height = [textDecoration zb_safeFloatValueForKey:@"height" defaultValue:1];
            CGFloat offset = [textDecoration zb_safeFloatValueForKey:@"offset" defaultValue:0];
            CALayer *decorationLayer = [CALayer layer];
            decorationLayer.backgroundColor = decorationColor.CGColor;
            decorationLayer.frame = CGRectMake(0, CGRectGetMinY(textLayer.frame) + CGRectGetHeight(textLayer.frame) * 0.5 + -height * 0.5 + offset, CGRectGetWidth(containerLayer.frame), height);
            [containerLayer addSublayer:decorationLayer];
        }
        [containerLayer addSublayer:textLayer];
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    if (tapAction) {
        [atr yy_setTextHighlightRange:NSMakeRange(0, YYTextAttachmentToken.length) color:[UIColor clearColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text1, NSRange range, CGRect rect) {
            tapAction(containerView,textAttributedString,range,rect);
        }];
    }
    
    if (baselineFont) {
        //垂直居中: 先底部对齐,再偏移字体高度的一半;
        CGFloat interval = (baselineFont.descender - font.descender) + (baselineFont.lineHeight - font.lineHeight) / 2;
        
        for (CALayer *subLayer in containerLayer.sublayers) {
            CGRect subLayerFrame = subLayer.frame;
            subLayerFrame.origin.y -= interval;
            subLayer.frame = subLayerFrame;
        }
    }
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = containerLayer;
    attach.contentMode = YYTextVerticalAlignmentCenter;
    [atr yy_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = containerSize.width;
    
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat yOffset = font.ascender - fontHeight * 0.5;
    delegate.ascent = containerSize.height * 0.5 + yOffset;
    delegate.descent = containerSize.height - delegate.ascent;
    if (delegate.descent < 0) {
        delegate.descent = 0;
        delegate.ascent = containerSize.height;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    ZBImageTextItem *item = [[ZBImageTextItem alloc] init];
    item.attributedString = [atr copy];
    item.size = containerSize;
    if (itemBlock) {
        itemBlock(item);
    }
    return item;
}

@end
