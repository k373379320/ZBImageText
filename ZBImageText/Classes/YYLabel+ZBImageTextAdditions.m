//
//  YYLabel+ZBImageTextAdditions.m
//  ZBImageTextProject
//
//  Created by xzb on 2019/3/2.
//  Copyright © 2019 xzb. All rights reserved.
//

#import "YYLabel+ZBImageTextAdditions.h"

@implementation YYLabel (ZBImageTextAdditions)

- (void)zb_makeContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block
{
    self.attributedText = [[self class] zb_attributedStringWithContexts:block];
}

- (void)zb_makeContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block globalConfig:(NSDictionary *)globalConfig
{
    self.attributedText = [[self class] zb_attributedStringWithContexts:block globalConfig:globalConfig];
}

+ (NSAttributedString *)zb_attributedStringWithContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block
{
    return [self zb_attributedStringWithContexts:block globalConfig:nil];
}

+ (NSAttributedString *)zb_attributedStringWithContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block globalConfig:(NSDictionary *)globalConfig
{
    ZBImageTextMaker *maker = [[ZBImageTextMaker alloc] init];
    if (block) block(maker);
    [maker setupGlobalConfig:globalConfig];
    return [maker install];
}

@end
