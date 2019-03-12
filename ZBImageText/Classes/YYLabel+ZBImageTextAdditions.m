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

+ (NSAttributedString *)zb_attributedStringWithContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block
{
    ZBImageTextMaker *maker = [[ZBImageTextMaker alloc] init];
    if (block) block(maker);
    return [maker install];
}
@end
