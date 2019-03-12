//
//  ZBFancyItem.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBFancyItem.h"

@implementation ZBFancyItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemSize = CGSizeZero;
        _itemSizeSel = NSSelectorFromString(@"itemSize:");
        _configSel = NSSelectorFromString(@"loadData:");
    }

    return self;
}

@end
