//
//  UICollectionView+ZBFancy.h
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCollectionProtoFactory.h"
#import "ZBCollectionMaker.h"
#import "ZBCollectionViewDataSource.h"
#import "ZBFancyCollectionData.h"
#import "ZBFancyLayout.h"

@interface UICollectionView (ZBDataSource)

@property (nonatomic, strong, readonly) ZBCollectionViewDataSource *zb_dataSource;
@property (nonatomic, strong, readonly) ZBFancyCollectionData *zb_collectionData;

@end

@interface UICollectionView (ZBFancy)

@property (nonatomic, strong) ZBFancyLayout *fancyLayout;

/**
 * 支持任意size布局
 */
+ (instancetype)fancyLayoutWithStyle:(ZBFancyCollectionViewStyle)style;

/**
 * UICollectionViewFlowLayout
 */
+ (instancetype)flowLayout;

/**
 * 自定义
 */
+ (instancetype)collectionViewWithLayout:(UICollectionViewLayout *)layout;

- (void)zb_configTableView:(void (^)(ZBCollectionProtoFactory *config))block;

//会reloadData
- (void)zb_setup:(void (^)(ZBCollectionMaker *maker))block;

//不会reloadData
- (void)zb_replaceSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block;

//不会reloadData
- (void)zb_appendSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block;

//不会reloadData
- (void)zb_appendRowsForSection:(NSString *)tag block:(void (^)(ZBCollectionMaker *maker))block;

@end
