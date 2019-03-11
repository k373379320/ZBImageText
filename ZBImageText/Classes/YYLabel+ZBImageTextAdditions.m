//
//  YYLabel+ZBImageTextAdditions.m
//  ZBImageTextProject
//
//  Created by xzb on 2019/3/2.
//  Copyright © 2019 xzb. All rights reserved.
//

#import "YYLabel+ZBImageTextAdditions.h"

#ifdef DEBUG
#define kStartTime CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#define kEnd(__log__) CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime); NSLog(@"📝--%@-->  %f ms", __log__, linkTime * 1000.0);
#else
#define kStartTime
#define kEnd(__log__)
#endif

@implementation YYLabel (ZBImageTextAdditions)

- (void)ZB_makeContexts:(void(NS_NOESCAPE ^)(ZBImageTextMaker *make))block
{
    kStartTime;
    ZBImageTextMaker *maker = [[ZBImageTextMaker alloc] init];
    if (block) block(maker);
    self.attributedText = [maker install];
    kEnd(@"生成->赋值最终耗时");
}

@end
