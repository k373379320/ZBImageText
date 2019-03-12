//
//  ZBCollectionProtoFactory.h
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, ZBCollectionViewConfigType) {
    ZBCollectionViewConfigTypeCell       = 0,
    ZBCollectionViewConfigTypeHeaderView = 1,
    ZBCollectionViewConfigTypeFooterView = 2
};

@interface ZBCollectionViewCellConfig : NSObject

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ type)(ZBCollectionViewConfigType);

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ identifier)(NSString *protoName);

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ cls)(NSString *clsName);

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ nibName)(NSString *nibName);

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ nib)(UINib *nib);

@end

@interface ZBCollectionProtoFactory : NSObject

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ headerView)(NSString *protoType);
@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ footerView)(NSString *protoType);

@property (nonatomic, copy) ZBCollectionViewCellConfig * (^ cell)(NSString *protoType);

- (NSArray *)install;

@end
