//
//  ZBCollectionProtoFactory.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBCollectionProtoFactory.h"

@interface ZBCollectionViewCellConfig ()

@property (nonatomic, strong) NSMutableDictionary *configs;

@end
@implementation ZBCollectionViewCellConfig

- (NSMutableDictionary *)configs
{
    if (!_configs) {
        _configs = [[NSMutableDictionary alloc] init];
    }
    return _configs;
}

- (ZBCollectionViewCellConfig * (^)(ZBCollectionViewConfigType))type
{
    return ^id(NSInteger type) {
        self.configs[@"type"] = @(type);
        return self;
    };
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )identifier
{
    return ^id(NSString *protoName) {
        self.configs[@"proto"] = protoName;
        return self;
    };
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )cls
{
    return ^id(NSString *clsName) {
        self.configs[@"class"] = clsName;
        return self;
    };
}

- (ZBCollectionViewCellConfig * (^)(UINib *) )nib
{
    return ^id(UINib *nib) {
        self.configs[@"nib"] = nib;
        return self;
    };
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )nibName
{
    return ^id(NSString *nib) {
        self.configs[@"nibName"] = nib;
        return self;
    };
}

@end

@interface ZBCollectionProtoFactory ()

@property (nonatomic, strong) NSMutableArray *cellConfigs;

@end

@implementation ZBCollectionProtoFactory

- (NSMutableArray *)cellConfigs
{
    if (!_cellConfigs) {
        _cellConfigs = [[NSMutableArray alloc] init];
    }
    return _cellConfigs;
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )headerView
{
    return ^id(NSString *protoType) {
        ZBCollectionViewCellConfig *protoConfig = [[ZBCollectionViewCellConfig alloc] init];
        protoConfig.type(ZBCollectionViewConfigTypeHeaderView);
        protoConfig.identifier(protoType);
        [self.cellConfigs addObject:protoConfig];
        return protoConfig;
    };
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )footerView
{
    return ^id(NSString *protoType) {
        ZBCollectionViewCellConfig *protoConfig = [[ZBCollectionViewCellConfig alloc] init];
        protoConfig.type(ZBCollectionViewConfigTypeFooterView);
        protoConfig.identifier(protoType);
        [self.cellConfigs addObject:protoConfig];
        return protoConfig;
    };
}

- (ZBCollectionViewCellConfig * (^)(NSString *) )cell
{
    return ^id(NSString *protoType) {
        ZBCollectionViewCellConfig *protoConfig = [[ZBCollectionViewCellConfig alloc] init];
        protoConfig.type(ZBCollectionViewConfigTypeCell);
        protoConfig.identifier(protoType);
        [self.cellConfigs addObject:protoConfig];
        return protoConfig;
    };
}

- (NSArray *)install
{
    return [self.cellConfigs zbbk_map:^(ZBCollectionViewCellConfig *proto) {
        return proto.configs;
    }];
}
@end
