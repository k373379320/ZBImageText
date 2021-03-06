//
//  YYLabel+ZBImageTextAdditions.h
//  ZBImageTextProject
//
//  Created by xzb on 2019/3/2.
//  Copyright © 2019 xzb. All rights reserved.
//

#import <YYText/YYText.h>
#import "YYLabel.h"
#import "ZBImageTextMaker.h"

@interface YYLabel (ZBImageTextAdditions)

- (void)zb_makeContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block;
- (void)zb_makeContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block globalConfig:(NSDictionary *)globalConfig;

+ (NSAttributedString *)zb_attributedStringWithContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block;
+ (NSAttributedString *)zb_attributedStringWithContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block globalConfig:(NSDictionary *)globalConfig;

@end
