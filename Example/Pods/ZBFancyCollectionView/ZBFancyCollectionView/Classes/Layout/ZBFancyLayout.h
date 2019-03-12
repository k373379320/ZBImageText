//
//  ZBFancyLayout.h
//  XZBProduct
//
//  Created by xzb on 2018/7/24.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBFancyLayoutHelper.h"

typedef NS_ENUM (NSUInteger, ZBFancyCollectionViewStyle) {
    ZBFancyCollectionViewStylePlain,   //头部会悬停
    ZBFancyCollectionViewStyleGrouped, //头部不会悬停
    ZBFancyCollectionViewStyleCustom   //自定义,可支持指定sectionHeader悬停
};

@interface ZBFancyLayout : UICollectionViewLayout

@property (nonatomic, strong) ZBFancyLayoutHelper *layoutHelper;

@property (nonatomic, strong) NSMutableArray<ZBFancyLayoutItem *> *dataArray;

@property (nonatomic, assign) ZBFancyCollectionViewStyle style;
/**
 如果type = ZBFancyCollectionViewStyleCustom,需要指定hoverIndexPath,默认第一个
 */
@property (nonatomic, strong) NSIndexPath *hoverIndexPath;

- (NSInteger)sectionCount;

@end
