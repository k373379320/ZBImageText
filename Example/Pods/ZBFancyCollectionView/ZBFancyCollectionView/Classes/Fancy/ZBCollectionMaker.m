//
//  ZBCollectionMaker.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBCollectionMaker.h"

@implementation ZBCollectionViewSectionMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _section = [[ZBSection alloc] init];
    }
    return self;
}

@end

@implementation ZBCollectionRowMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.row = [[ZBFancyItem alloc] init];
    }
    
    return self;
}

- (ZBCollectionRowMaker * (^)(CGSize))itemSize
{
    return ^id(CGSize size) {
        self.row.itemSize = size;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(id))model
{
    return ^id(id m) {
        self.row.rawModel = m;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(NSString *) )tag
{
    return ^id(NSString *t) {
        self.row.tag = t;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(SEL))configureSEL
{
    return ^id(SEL s) {
        self.row.configSel = s;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(SEL))itemSizeSEL
{
    return ^id(SEL s) {
        self.row.itemSizeSel = s;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(UICollectionViewCell * (^)(id)))constructBlock
{
    return ^id(UICollectionViewCell * (^block)(id)) {
        self.row.constructBlock = block;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(void (^)(id)))selectBlock
{
    return ^id(void (^selectHandler)(id)) {
        self.row.selectHandler = selectHandler;
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(NSDictionary *) )extraDictBlock
{
    return ^ZBCollectionRowMaker *(NSDictionary *extraDict)
    {
        self.row.extraDict = [extraDict copy];
        return self;
    };
}

- (ZBCollectionRowMaker * (^)(NSBundle *) )bundle
{
    return ^ZBCollectionRowMaker *(NSBundle *bundle)
    {
        self.row.bundle = bundle;
        return self;
    };
}

@end

@interface ZBCollectionMaker ()

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) ZBCollectionViewSectionMaker *currentSectionMaker;

@end

@implementation ZBCollectionMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (ZBCollectionViewSectionMaker * (^)(NSString *key))section
{
    __weak typeof(self) weakSelf = self;
    return ^id(NSString *key) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZBCollectionViewSectionMaker *sectionMaker = [[ZBCollectionViewSectionMaker alloc] init];
        [strongSelf.sections addObject:sectionMaker];
        strongSelf.currentSectionMaker = sectionMaker;
        sectionMaker.section.key = key;
        return sectionMaker;
    };
}

- (ZBCollectionRowMaker * (^)(NSString *) )sectionHeader
{
    __weak typeof(self) weakSelf = self;
    return ^id(NSString *proto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZBCollectionRowMaker *rowMaker = [[ZBCollectionRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        strongSelf.currentSectionMaker.section.headerView = rowMaker.row;
        return rowMaker;
    };
}

- (ZBCollectionRowMaker * (^)(NSString *) )sectionFooter
{
    __weak typeof(self) weakSelf = self;
    return ^id(NSString *proto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZBCollectionRowMaker *rowMaker = [[ZBCollectionRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        strongSelf.currentSectionMaker.section.footerView = rowMaker.row;
        return rowMaker;
    };
}

- (ZBCollectionRowMaker * (^)(NSString *) )row
{
    __weak typeof(self) weakSelf = self;
    return ^id(NSString *proto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ZBCollectionRowMaker *rowMaker = [[ZBCollectionRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        [strongSelf.currentSectionMaker.section appendRows:@[rowMaker.row]];
        return rowMaker;
    };
}

- (NSArray *)install
{
    return [_sections zbbk_map:^id(ZBCollectionViewSectionMaker *sectionMaker) {
        return sectionMaker.section;
    }];
}

@end
