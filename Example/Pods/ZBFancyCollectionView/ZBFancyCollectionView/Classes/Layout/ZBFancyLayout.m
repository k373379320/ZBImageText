//
//  ZBFancyLayout.m
//  XZBProduct
//
//  Created by xzb on 2018/7/24.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBFancyLayout.h"

@interface ZBFancyLayout ()

@property (nonatomic, assign) CGFloat contentSizeHeight;

@property (nonatomic, assign) NSInteger sectionCount;

- (NSInteger)sectionCount;

@end

@implementation ZBFancyLayout

#pragma mark - lifeCycle
- (void)prepareLayout
{
    [super prepareLayout];

    [self.layoutHelper makeLayoutDataWithItems:self.dataArray];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, MAX([self.layoutHelper contentSizeHeight], CGRectGetHeight([UIScreen mainScreen].bounds)));
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (ZBFancyCollectionViewStyleGrouped == self.style) {
        return [self.layoutHelper layoutAttributes];
    }
    if (ZBFancyCollectionViewStylePlain == self.style) {
        NSMutableArray *origLayoutAttributes = [self.layoutHelper layoutAttributes];
        UICollectionViewLayoutAttributes *selectedHeader = nil;
        for (UICollectionViewLayoutAttributes *attributes in origLayoutAttributes) {
            if (attributes.representedElementKind == UICollectionElementKindSectionHeader || (attributes.representedElementKind == UICollectionElementKindSectionFooter)) {
                UICollectionViewLayoutAttributes *headerAttributes = attributes;
                if (!selectedHeader) {
                    //第一个y = 0
                    CGRect headerRect = headerAttributes.frame;
                    headerRect.origin.y = self.collectionView.contentOffset.y;
                    headerAttributes.frame = headerRect;
                    selectedHeader = headerAttributes;
                } else {
                    //下一个sectionHeader进来,则上滑
                    if (CGRectGetMinY(headerAttributes.frame) < CGRectGetMaxY(selectedHeader.frame)) {
                        CGRect selectedRect = selectedHeader.frame;
                        selectedRect.origin.y = CGRectGetMinY(headerAttributes.frame) - CGRectGetHeight(selectedHeader.frame);
                        selectedHeader.frame = selectedRect;
                    }
                    //小于contentOffsetY 则停止
                    if (CGRectGetMinY(headerAttributes.frame) <= self.collectionView.contentOffset.y) {
                        CGRect headerRect = headerAttributes.frame;
                        headerRect.origin.y = self.collectionView.contentOffset.y;
                        headerAttributes.frame = headerRect;
                        selectedHeader = headerAttributes;
                    }
                }
            }
        }
        return origLayoutAttributes;
    }
    if (ZBFancyCollectionViewStyleCustom == self.style) {
        NSMutableArray *origLayoutAttributes = [self.layoutHelper layoutAttributes];
        for (UICollectionViewLayoutAttributes *attributes in origLayoutAttributes) {
            if (attributes.representedElementKind == UICollectionElementKindSectionHeader && ([attributes.indexPath compare:self.hoverIndexPath] == NSOrderedSame)) {
                UICollectionViewLayoutAttributes *headerAttributes = attributes;
                CGRect headerRect = headerAttributes.frame;
                headerRect.origin.y = self.collectionView.contentOffset.y;
                headerAttributes.frame = headerRect;
            }
        }
        return origLayoutAttributes;
    }
    return [self.layoutHelper layoutAttributes];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    if (ZBFancyCollectionViewStyleGrouped == self.style) {
        return NO;
    }
    return YES;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    ZBFancyLayoutSection *section = [self.layoutHelper sectionDatas][indexPath.section];
    if ([section.headerView.layoutAttributes.representedElementKind isEqualToString:elementKind]) {
        return section.headerView.layoutAttributes;
    }
    if ([section.footerView.layoutAttributes.representedElementKind isEqualToString:elementKind]) {
        return section.footerView.layoutAttributes;
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancyLayoutSection *section = [self.layoutHelper sectionDatas][indexPath.section];
    ZBFancyLayoutItem *item = section.items[indexPath.item];
    return item.layoutAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    ZBFancyLayoutSection *section = [self.layoutHelper sectionDatas][indexPath.section];
    if ([section.headerView.layoutAttributes.representedElementKind isEqualToString:elementKind]) {
        return section.headerView.layoutAttributes;
    }
    if ([section.footerView.layoutAttributes.representedElementKind isEqualToString:elementKind]) {
        return section.footerView.layoutAttributes;
    }
    return nil;
}

#pragma mark - private

#pragma mark - lazy

ZBLazyPropertyWithInit(ZBFancyLayoutHelper, layoutHelper,
{
    _layoutHelper.layout = self;
});

ZBLazyProperty(NSMutableArray, dataArray);

@end
