//
//  ZBFancyLayoutHelper.h
//  ZBFancyCollectionView
//
//  Created by xzb on 2018/7/27.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, ZBFancyLayoutItemType) {
    ZBFancyLayoutItemTypeCell,
    ZBFancyLayoutItemTypeSectionHeader,
    ZBFancyLayoutItemTypeSectionFooter,
};

@interface ZBFancyLayoutItem : NSObject

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) UIEdgeInsets margin;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *layoutAttributes;

@property (nonatomic, assign) ZBFancyLayoutItemType itemType;

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface ZBFancyLayoutSection : NSObject

@property (nonatomic, strong) ZBFancyLayoutItem *headerView;
@property (nonatomic, strong) ZBFancyLayoutItem *footerView;
@property (nonatomic, strong) NSMutableArray<ZBFancyLayoutItem *> *items;

@end

@interface ZBFancyLayoutHelper : NSObject

@property (nonatomic, weak) UICollectionViewLayout *layout;

//布局
- (void)makeLayoutDataWithItems:(NSArray<ZBFancyLayoutItem *> *)items;
//所有item布局
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes;
//content
- (CGFloat)contentSizeHeight;
//所有item数据
- (NSMutableArray<ZBFancyLayoutSection *> *)sectionDatas;

@end
