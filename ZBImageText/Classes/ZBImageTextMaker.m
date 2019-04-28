//
//  ZBImageTextMaker.m
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/28.
//  Copyright © 2019 xzb. All rights reserved.
//

#import "ZBImageTextMaker.h"
#import "ZBImageTextEngine.h"
#import "ZBImageText.h"

@interface ZBImageTextMaker ()
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSDictionary *globalConfig;

@end
@implementation ZBImageTextMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = NSMutableArray.new;
    }
    return self;
}

- (NSAttributedString *)install
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.items.count];
    for (ZBImageText *it in self.items) {
        if (it.info) {
            if (self.globalConfig) {
                [it.info addEntriesFromDictionary:self.globalConfig];
            }
            [items addObject:[it.info copy]];
        }
    }
    return  [ZBImageTextEngine attributedStringFromData:items];
}

- (void)setupGlobalConfig:(NSDictionary *)config
{
    if (config) {
        self.globalConfig = [config copy];
    }
}

- (void (^)(CGFloat width))space
{
    return ^void(CGFloat width){
        if (width <= 0) {
            return;
        }
        ZBImageText *it = [[ZBImageText alloc] init];
        it.info[@"space"] = @(width);
        [self.items addObject:it];
    };
}

- (ZBImageTextItemImage * (^)(UIImage *image))image
{
    return ^id(UIImage *image){
        if (!image) {
            return nil;
        }
        ZBImageTextItemImage *it = [[ZBImageTextItemImage alloc] init];
        it.info[@"image"] = image;
        [self.items addObject:it];
        return it;
    };
}

- (ZBImageTextItemText * (^)(NSString *text))text
{
    return ^id(NSString *text){
        if (text.length == 0) {
            return nil;;
        }
        ZBImageTextItemText *it = [[ZBImageTextItemText alloc] init];
        it.info[@"text"] = text;
        [self.items addObject:it];
        return it;
    };
}



@end
