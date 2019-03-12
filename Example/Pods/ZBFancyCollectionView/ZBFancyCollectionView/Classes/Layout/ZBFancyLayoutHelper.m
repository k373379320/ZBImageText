//
//  ZBFancyLayoutHelper.m
//  ZBFancyCollectionView
//
//  Created by xzb on 2018/7/27.
//

#import "ZBFancyLayoutHelper.h"

@implementation ZBFancyLayoutItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.margin = UIEdgeInsetsZero;
    }
    return self;
}

@end

@implementation ZBFancyLayoutSection
@end

@interface ZBFancyLayoutHelper ()
//记录所有布局数据
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;
//记录当前最下面一排可供添加的的rect
@property (nonatomic, strong) NSMutableArray *rectArray;

@property (nonatomic, assign) CGFloat contentSizeHeight;

@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) NSMutableArray<ZBFancyLayoutSection *> *sectionDatas;

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes;

- (CGFloat)contentSizeHeight;

- (NSMutableArray<ZBFancyLayoutSection *> *)sectionDatas;
@end

@implementation ZBFancyLayoutHelper

#pragma mark - API
- (void)makeLayoutDataWithItems:(NSArray<ZBFancyLayoutItem *> *)items
{
    [self.sectionDatas removeAllObjects];
    [self.layoutAttributes removeAllObjects];
    [self.rectArray removeAllObjects];
    [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0)]];
    
    __block ZBFancyLayoutItem *lastItem = nil;
    __block NSInteger sectionCount = 0;
    __block NSInteger currentIndexPathRow = 0;
    __block NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    __weak typeof(self)weakSelf = self;
    
    [items enumerateObjectsUsingBlock:^(ZBFancyLayoutItem *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UICollectionViewLayoutAttributes *layoutAttributes = nil;
        
        if (item.itemType == ZBFancyLayoutItemTypeSectionHeader) {
            indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:sectionCount];
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            layoutAttributes.zIndex = 20 + sectionCount;
            sectionCount++;
            currentIndexPathRow = 0;
            
            ZBFancyLayoutSection *section = [[ZBFancyLayoutSection alloc] init];
            section.headerView = item;
            section.items = [[NSMutableArray alloc] init];
            [self.sectionDatas addObject:section];
        }
        
        if (item.itemType == ZBFancyLayoutItemTypeCell) {
            if (sectionCount == 0) {
                //没有headView
                ZBFancyLayoutSection *section = [[ZBFancyLayoutSection alloc] init];
                section.items = [[NSMutableArray alloc] init];
                [self.sectionDatas addObject:section];
            }
            indexPath = [NSIndexPath indexPathForItem:currentIndexPathRow inSection:indexPath.section];
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            currentIndexPathRow++;
            ZBFancyLayoutSection *section = strongSelf.sectionDatas[indexPath.section];
            [section.items addObject:item];
        }
        
        if (item.itemType == ZBFancyLayoutItemTypeSectionFooter) {
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionCount - 1]];
            ZBFancyLayoutSection *section = strongSelf.sectionDatas[indexPath.section];
            section.footerView = item;
        }
        
        CGRect targetRect = [self targetRectWithWidth:MIN(CGRectGetWidth([UIScreen mainScreen].bounds), item.size.width + item.margin.left) height:item.size.height + item.margin.top];
        CGFloat x = CGRectGetMinX(targetRect) + item.margin.left;
        CGFloat y = CGRectGetMaxY(targetRect) + item.margin.top;
        CGFloat w = item.size.width;
        CGFloat h = item.size.height;
        if (x + w > CGRectGetWidth([UIScreen mainScreen].bounds)) {
            x = 0;
            w = CGRectGetWidth([UIScreen mainScreen].bounds);
        }
        if (layoutAttributes) {
            layoutAttributes.frame = CGRectMake(x, y, w, h);
            [self.layoutAttributes addObject:layoutAttributes];
            item.layoutAttributes = layoutAttributes;
        }
        lastItem = item;
        self.contentSizeHeight = y + h;
    }];
    
    self.sectionCount = sectionCount + 1;
}

/**
 * 查找符合条件Rect
 *
 * 1.查找符合的rect,如果找到了就返回targetRect;
 * rectArray 会做以下处理
 * 如果 targetRect.width > width 分裂2个rect;
 * 如果 targetRect.width = width 替换rect;
 * 如果 targetRect.width < width 另起一行,重新计算;
 */
- (CGRect)targetRectWithWidth:(CGFloat)width height:(CGFloat)height
{
    CGRect maxHeightRect = [[self.rectArray firstObject] CGRectValue];
    CGRect targetRect = [[self.rectArray firstObject] CGRectValue];
    NSUInteger selectedIdx = 0;
    // targetRect.width >= width 且maxY最低
    if (self.rectArray.count > 1) {
        for (NSInteger idx = 0; idx < self.rectArray.count; idx++) {
            CGRect rect = [self.rectArray[idx] CGRectValue];
            if (CGRectGetWidth(rect) >= width && (CGRectGetMaxY(rect) < CGRectGetMaxY(targetRect))) {
                targetRect = rect;
                selectedIdx = idx;
            }
            if (CGRectGetHeight(rect) > CGRectGetHeight(maxHeightRect)) {
                maxHeightRect = rect;
            }
        }
    }
    
    if (CGRectGetWidth(targetRect) < width) {
        targetRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetMaxY(maxHeightRect));
        [self handleGreaterCaseWithWidth:width height:height targetRect:targetRect selectedIdx:selectedIdx maxHeightRect:maxHeightRect];
        return targetRect;
    }
    
    if (CGRectGetWidth(targetRect) > width) {
        [self handleLessThanCaseWithWidth:width height:height targetRect:targetRect selectedIdx:selectedIdx];
    } else {
        [self handleEqualCaseWithWidth:width height:height targetRect:targetRect selectedIdx:selectedIdx];
    }
    
    [self handleSortedArray];
    
    [self handleMergeRect];
    
    return targetRect;
}

- (void)handleLessThanCaseWithWidth:(CGFloat)width height:(CGFloat)height targetRect:(CGRect)targetRect selectedIdx:(NSUInteger)selectedIdx
{
    //分裂
    [self.rectArray removeObjectAtIndex:selectedIdx];
    CGRect rect1 = CGRectMake(CGRectGetMinX(targetRect), 0, width, CGRectGetMaxY(targetRect) + height);
    CGRect rect2 = CGRectMake(CGRectGetMinX(targetRect) + CGRectGetWidth(rect1), 0, CGRectGetWidth(targetRect) - CGRectGetWidth(rect1), CGRectGetHeight(targetRect));
    [self.rectArray addObject:[NSValue valueWithCGRect:rect1]];
    [self.rectArray addObject:[NSValue valueWithCGRect:rect2]];
}

- (void)handleEqualCaseWithWidth:(CGFloat)width height:(CGFloat)height targetRect:(CGRect)targetRect selectedIdx:(NSUInteger)selectedIdx
{
    //替换
    CGRect rect = CGRectMake(CGRectGetMinX(targetRect), 0, width, CGRectGetMaxY(targetRect) + height);
    if (width == CGRectGetWidth([UIScreen mainScreen].bounds)) {
        [self.rectArray removeAllObjects];
        [self.rectArray addObject:[NSValue valueWithCGRect:rect]];
    } else {
        CGRect rect = CGRectMake(CGRectGetMinX(targetRect), 0, width, CGRectGetMaxY(targetRect) + height);
        [self.rectArray replaceObjectAtIndex:selectedIdx withObject:[NSValue valueWithCGRect:rect]];
    }
}

- (void)handleGreaterCaseWithWidth:(CGFloat)width height:(CGFloat)height targetRect:(CGRect)targetRect selectedIdx:(NSUInteger)selectedIdx maxHeightRect:(CGRect)maxHeightRect
{
    //另起一行
    [self.rectArray removeAllObjects];
    targetRect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetMaxY(maxHeightRect));
    CGRect rect1 = CGRectMake(0, 0, width, CGRectGetMaxY(targetRect) + height);
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1), 0, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(rect1), CGRectGetMaxY(targetRect));
    [self.rectArray addObject:[NSValue valueWithCGRect:rect1]];
    [self.rectArray addObject:[NSValue valueWithCGRect:rect2]];
}

/**
 *  如果相邻的rect,高度一样,则合并成一个
 */
- (void)handleMergeRect
{
    for (NSInteger idx = 0; idx < self.rectArray.count; idx++) {
        NSValue *obj1 = self.rectArray[idx];
        CGRect rect = [obj1 CGRectValue];
        for (NSInteger subIdx = idx - 1; subIdx >= 0; subIdx--) {
            NSValue *obj2 = self.rectArray[subIdx];
            CGRect subRect = [obj2 CGRectValue];
            if (CGRectGetHeight(subRect) == CGRectGetHeight(rect)) {
                if (CGRectGetMinX(rect) == CGRectGetMaxX(subRect)) {
                    CGRect mergeRect = CGRectMake(CGRectGetMinX(subRect), 0, CGRectGetWidth(subRect) + CGRectGetWidth(rect), CGRectGetHeight(subRect));
                    [self.rectArray insertObject:[NSValue valueWithCGRect:mergeRect] atIndex:subIdx];
                    [self.rectArray removeObject:obj1];
                    [self.rectArray removeObject:obj2];
                    [self handleMergeRect];
                    return;
                }
            }
        }
    }
}

/**
 * 排序一下,下次添加按照左边加;想右边开始排,翻一下
 */
- (void)handleSortedArray
{
    self.rectArray = [self.rectArray sortedArrayUsingComparator:^NSComparisonResult (NSValue *obj1, NSValue *obj2) {
        return obj1.CGRectValue.origin.x > obj2.CGRectValue.origin.x;
    }].mutableCopy;
}

#pragma mark - private

#pragma mark - lazy
ZBLazyProperty(NSMutableArray, sectionDatas);

ZBLazyProperty(NSMutableArray, layoutAttributes);
ZBLazyPropertyWithInit(NSMutableArray, rectArray,
{
    [_rectArray addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0)]];
});

@end
