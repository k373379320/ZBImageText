//
//  ZBFancyItem.h
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBFancyItem : NSObject

@property (nonatomic, copy) NSString *protoType;

@property (nonatomic, strong) id rawModel;

@property (nonatomic, strong) NSDictionary *extraDict;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) SEL configSel;

@property (nonatomic, assign) SEL itemSizeSel;

@property (nonatomic, copy) void (^ selectHandler)(id);

@property (nonatomic, copy) UICollectionViewCell * (^ constructBlock)(id);

@property (nonatomic, copy) void (^ configureBlock)(id);

@property (nonatomic, strong) NSBundle *bundle;

@end
