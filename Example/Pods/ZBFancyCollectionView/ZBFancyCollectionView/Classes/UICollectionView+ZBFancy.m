//
//  UICollectionView+ZBFancy.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "UICollectionView+ZBFancy.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char kDataSourceKey;

@implementation UICollectionView (ZBDataSource)

- (ZBCollectionViewDataSource *)zb_dataSource
{
    ZBCollectionViewDataSource *ds = objc_getAssociatedObject(self, &kDataSourceKey);
    if (!ds) {
        ds = [[ZBCollectionViewDataSource alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, &kDataSourceKey, ds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!self.dataSource) {
            self.dataSource = ds;
            self.delegate = ds;
        }
    }
    return ds;
}

- (ZBFancyCollectionData *)zb_collectionData
{
    return self.zb_dataSource.collectionData;
}

@end
@implementation UICollectionView (ZBFancy)

static const void *kProperty_fancyLayout = &kProperty_fancyLayout;

- (void)setFancyLayout:(ZBFancyLayout *)fancyLayout
{
    objc_setAssociatedObject(self, kProperty_fancyLayout, fancyLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZBFancyLayout *)fancyLayout
{
    return objc_getAssociatedObject(self, kProperty_fancyLayout);
}

+ (instancetype)fancyLayoutWithStyle:(ZBFancyCollectionViewStyle)style
{
    ZBFancyLayout *layout = [[ZBFancyLayout alloc] init];
    layout.style = style;
    UICollectionView *collection = [self collectionViewWithLayout:layout];
    collection.fancyLayout = layout;
    return collection;
}

+ (instancetype)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /* 9.0之后实现头部悬停
     if (@available(iOS 9.0, *)) {
     layout.sectionHeadersPinToVisibleBounds = YES;
     } else {
     
     }
     */
    return [self collectionViewWithLayout:layout];
}

+ (instancetype)collectionViewWithLayout:(UICollectionViewLayout *)layout
{
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    return collection;
}

- (void)zb_configTableView:(void (^)(ZBCollectionProtoFactory *config))block
{
    ZBCollectionProtoFactory *config = [[ZBCollectionProtoFactory alloc] init];
    if (block) block(config);
    NSArray *configs = [config install];
    [configs enumerateObjectsUsingBlock:^(NSDictionary *config, NSUInteger idx, BOOL *_Nonnull stop) {
        ZBCollectionViewConfigType type = (config[@"type"] ? [config[@"type"] integerValue] : ZBCollectionViewConfigTypeCell);
        
        if (type == ZBCollectionViewConfigTypeCell) {
            if (config[@"nibName"]) {
                UINib *nib = [UINib nibWithNibName:config[@"nibName"] bundle:nil];
                [self.zb_dataSource registerNib:nib cellClass:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            } else if (config[@"nib"]) {
                [self.zb_dataSource registerNib:config[@"nib"] cellClass:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            } else {
                [self.zb_dataSource registerCell:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            }
        } else if (type == ZBCollectionViewConfigTypeHeaderView) {
            if (config[@"nibName"]) {
                UINib *nib = [UINib nibWithNibName:config[@"nibName"] bundle:nil];
                [self.zb_dataSource registerHeaderNib:nib viewClass:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            } else {
                [self.zb_dataSource registerHeaderView:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            }
        } else if (type == ZBCollectionViewConfigTypeFooterView) {
            if (config[@"nibName"]) {
                UINib *nib = [UINib nibWithNibName:config[@"nibName"] bundle:nil];
                [self.zb_dataSource registerFooterNib:nib viewClass:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            } else {
                [self.zb_dataSource registerFooterView:NSClassFromString(config[@"class"]) identifier:config[@"proto"]];
            }
        }
    }];
}

- (void)zb_setup:(void (^)(ZBCollectionMaker *maker))block
{
    ZBCollectionMaker *maker = [[ZBCollectionMaker alloc] init];
    block(maker);
    
    NSArray *sections = [maker install];
    
    [self.zb_dataSource updateAll:sections];
    
    [self handleFancyLayout];
    
    [self reloadData];
}

- (void)zb_replaceSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block
{
    ZBSection *section = [self.zb_collectionData sectionForKey:tag];
    if (section) {
        ZBCollectionMaker *maker = [[ZBCollectionMaker alloc] init];
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBSection *newSection = sections[0];
            [self.zb_collectionData replaceSection:section newSection:newSection];
            [self handleFancyLayout];
        }
    }
}

- (void)zb_appendSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block
{
    ZBSection *section = [self.zb_collectionData sectionForKey:tag];
    if (section) {
        ZBCollectionMaker *maker = [[ZBCollectionMaker alloc] init];
        maker.section(tag);
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBSection *sectionDataToAppend = sections[0];
            [section appendRows:sectionDataToAppend.rows];
            [self handleFancyLayout];
        }
    }
}

- (void)zb_appendRowsForSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block
{
    ZBSection *section = [self.zb_collectionData sectionForKey:tag];
    if (section) {
        ZBCollectionMaker *maker = [[ZBCollectionMaker alloc] init];
        maker.section(tag);
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBSection *sectionDataToAppend = sections[0];
            [section appendRows:sectionDataToAppend.rows];
            __weak typeof(self)weakSelf = self;
            [sectionDataToAppend.rows zbbk_each:^(ZBFancyItem *row) {
                ZBFancyLayoutItem *item = [weakSelf fancyLayoutItemWithFancyItem:row];
                if (item.size.width > 0) {
                    [weakSelf.fancyLayout.dataArray addObject:item];
                }
            }];
            [self handleFancyLayout];
        }
    }
}

#pragma mark - ZBFancyLayout

- (void)handleFancyLayout
{
    if (!self.fancyLayout) {
        return;
    }
    NSArray *sections = [self.zb_collectionData sections];
    if (sections.count < 1) {
        return;
    }
    [self.fancyLayout.dataArray removeAllObjects];
    __weak typeof(self)weakSelf = self;
    [sections zbbk_each:^(ZBSection *section) {
        if (section.headerView) {
            ZBFancyLayoutItem *item = [weakSelf fancyLayoutItemWithFancyItem:section.headerView];
            item.itemType = ZBFancyLayoutItemTypeSectionHeader;
            if (item.size.height <= 0) {
                item.size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGFLOAT_MIN);
            }
            [weakSelf.fancyLayout.dataArray addObject:item];
        }
        [section.rows zbbk_each:^(ZBFancyItem *row) {
            ZBFancyLayoutItem *item = [weakSelf fancyLayoutItemWithFancyItem:row];
            if (item.size.width > 0) {
                [weakSelf.fancyLayout.dataArray addObject:item];
            }
        }];
        if (section.footerView) {
            ZBFancyLayoutItem *item = [weakSelf fancyLayoutItemWithFancyItem:section.footerView];
            item.itemType = ZBFancyLayoutItemTypeSectionFooter;
            if (item.size.width > 0) {
                [weakSelf.fancyLayout.dataArray addObject:item];
            }
        }
    }];
}

- (ZBFancyLayoutItem *)fancyLayoutItemWithFancyItem:(ZBFancyItem *)item
{
    ZBFancyLayoutItem *layoutItem = [[ZBFancyLayoutItem alloc] init];
    NSMutableDictionary *protoTypes = [self.zb_dataSource valueForKey:@"protoTypes"];
    Class cls = protoTypes[item.protoType][@"class"];
    if (cls) {
        id model = item.rawModel;
        if ([cls respondsToSelector:item.itemSizeSel]) {
            layoutItem.size =  ZBGetSizeSendMsg(cls, item.itemSizeSel, model);
        }
        SEL sel = NSSelectorFromString(@"itemMargin:");
        if ([cls respondsToSelector:sel]) {
            layoutItem.margin = ZBGetEdgeInsetsSendMsg(cls, sel, model);
        }
    } else {
        NSAssert(cls != nil, @"❌ %@  is error", item.protoType);
    }
    return layoutItem;
}

@end
