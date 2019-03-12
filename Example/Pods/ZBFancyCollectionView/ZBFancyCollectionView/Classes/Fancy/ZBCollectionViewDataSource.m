//
//  ZBDataSource.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBCollectionViewDataSource.h"
#import "ZBFancyItem.h"
#import "ZBSection.h"
#import <objc/message.h>

static NSString *const ZBCollectionViewFancyProtoTypeIdentifierKey = @"identifier";
static NSString *const ZBCollectionViewFancyProtoTypeClassKey = @"class";
static NSString *const ZBCollectionViewFancyProtoTypeNibKey = @"nib";

@interface ZBCollectionViewDataSource ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *protoTypes;
@property (nonatomic, strong, readwrite) ZBFancyCollectionData *collectionData;

@end

@implementation ZBCollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _protoTypes = [NSMutableDictionary dictionary];
        _collectionData = [[ZBFancyCollectionData alloc] init];
    }
    return self;
}

- (void)registerHeaderView:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: viewClass };
    
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerFooterView:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: viewClass };
    
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)registerHeaderNib:(UINib *)nib viewClass:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: viewClass };
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerFooterNib:(UINib *)nib viewClass:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: viewClass };
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier
{
    NSAssert(identifier && [identifier length] > 0, @"identifer must not be empty");
    NSAssert(!(self.protoTypes[identifier]), @"%@ was already registerred", identifier);
    NSAssert(cellClass != nil, @"cellClass must not be nil");
    
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: cellClass };
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass identifier:(NSString *)identifier
{
    NSAssert(identifier && [identifier length] > 0, @"identifer must not be empty");
    NSAssert(!(self.protoTypes[identifier]), @"%@ was already registerred", identifier);
    NSAssert(cellClass != nil, @"cellClass must not be nil");
    NSAssert(nib, @"nib must not be nill");
    
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: cellClass,
                                 ZBCollectionViewFancyProtoTypeNibKey: nib };
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib headerFooterViewClass:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ ZBCollectionViewFancyProtoTypeClassKey: viewClass,
                                 ZBCollectionViewFancyProtoTypeNibKey: nib };
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)updateAll:(NSArray<__kindof ZBSection *> *)sections
{
    [self.collectionData resetWithSections:sections];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionData.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionData sectionAtIdx:section].rows.count;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self.collectionData sectionAtIdx:indexPath.section];
    ZBFancyItem *row = [section rowAtIdx:indexPath.row];
    if (row) {
        if (self.willDisplayCellHandler) {
            self.willDisplayCellHandler(collectionView, cell, indexPath, row.rawModel);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self.collectionData sectionAtIdx:indexPath.section];
    ZBFancyItem *row = [section rowAtIdx:indexPath.row];
    if (row) {
        if (self.didEndDisplayingCellHandler) {
            self.didEndDisplayingCellHandler(collectionView,  cell, indexPath, row.rawModel);
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self.collectionData sectionAtIdx:indexPath.section];
    ZBFancyItem *row = [section rowAtIdx:indexPath.row];
    
    if (row) {
        if (self.cellForRowHandler) {
            self.cellForRowHandler(collectionView, indexPath, row.rawModel);
        }
        
        if (row.constructBlock) {
            return row.constructBlock(row.rawModel);
        }
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:row.protoType forIndexPath:indexPath];
        if (row.configSel) {
            if ([cell respondsToSelector:row.configSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(cell, row.configSel, row.rawModel);
            }
        }
        
        if (row.configureBlock) {
            row.configureBlock(row.rawModel);
        }
        
        return cell;
    } else {
        return [[UICollectionViewCell alloc] init];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *sec = [self.collectionData sectionAtIdx:indexPath.section];
    if (!sec) {
        sec = [self.collectionData.sections firstObject];
    }
    if (sec && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZBFancyItem *row = sec.headerView;
        if (row) {
            if (row.constructBlock) {
                return row.constructBlock(row.rawModel);
            }
        }
        if (row.protoType.length > 0) {
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:row.protoType forIndexPath:indexPath];
            if ([reusableView respondsToSelector:row.configSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(reusableView, row.configSel, row.rawModel);
            }
            return reusableView;
        }
    }
    if (sec && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ZBFancyItem *row = sec.footerView;
        if (row) {
            if (row.constructBlock) {
                return row.constructBlock(row.rawModel);
            }
        }
        if (row.protoType.length > 0) {
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:row.protoType forIndexPath:indexPath];
            if ([reusableView respondsToSelector:row.configSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(reusableView, row.configSel, row.rawModel);
            }            
            return reusableView;
        }
    }
    UICollectionReusableView *reusableView = [[UICollectionReusableView alloc] init];
    return reusableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self.collectionData sectionAtIdx:indexPath.section];
    ZBFancyItem *row = [section rowAtIdx:indexPath.row];
    if (row.selectHandler) {
        row.selectHandler(row.rawModel);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self.collectionData sectionAtIdx:indexPath.section];
    ZBFancyItem *row = [section rowAtIdx:indexPath.row];
    
    if (row.itemSize.height > 0 || row.itemSize.width > 0) {
        return row.itemSize;
    }
    if (row.itemSizeSel) {
        Class cls = (_protoTypes[row.protoType] ? _protoTypes[row.protoType][ZBCollectionViewFancyProtoTypeClassKey] : nil);
        if (cls) {
            id model = row.rawModel;
            if ([cls respondsToSelector:row.itemSizeSel]) {
                return ZBGetSizeSendMsg(cls, row.itemSizeSel, model);
            }
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    ZBSection *sec = [self.collectionData sectionAtIdx:section];
    ZBFancyItem *row = sec.headerView;
    if (row) {
        if (row.itemSize.height > 0 || row.itemSize.width > 0) {
            return row.itemSize;
        }
        if (row.itemSizeSel) {
            Class cls = (_protoTypes[row.protoType] ? _protoTypes[row.protoType][ZBCollectionViewFancyProtoTypeClassKey] : nil);
            if (cls) {
                id model = row.rawModel;
                if ([cls respondsToSelector:row.itemSizeSel]) {
                    return ZBGetSizeSendMsg(cls, row.itemSizeSel, model);
                }
            }
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    ZBSection *sec = [self.collectionData sectionAtIdx:section];
    ZBFancyItem *row = sec.footerView;
    if (row) {
        if (row.itemSize.height > 0 || row.itemSize.width > 0) {
            return row.itemSize;
        }
        if (row.itemSizeSel) {
            Class cls = (_protoTypes[row.protoType] ? _protoTypes[row.protoType][ZBCollectionViewFancyProtoTypeClassKey] : nil);
            if (cls) {
                id model = row.rawModel;
                if ([cls respondsToSelector:row.itemSizeSel]) {
                    return ZBGetSizeSendMsg(cls, row.itemSizeSel, model);
                }
            }
        }
    }
    return CGSizeZero;
}

//item间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

@end
