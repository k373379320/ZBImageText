//
//  ZBTableData.h
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBSection, ZBFancyItem;

@interface ZBFancyCollectionData : NSObject

- (NSArray<NSString *> *)allSectionsKeys;

// section
- (NSArray<ZBSection *> *)sections;

- (ZBSection *)sectionAtIdx:(NSInteger)idx;

- (ZBSection *)sectionForKey:(NSString *)key;

- (void)resetWithSections:(NSArray<ZBSection *> *)sections;

- (void)replaceSection:(ZBSection *)section newSection:(ZBSection *)newSection;

- (void)appendSections:(NSArray<ZBSection *> *)sections;

- (void)insertSections:(NSArray<ZBSection *> *)sections atIdx:(NSUInteger)idx;

- (void)deleteSectionsForIdxs:(NSArray<NSNumber *> *)idxs;

- (void)deleteSectionsForKeys:(NSArray<NSString *> *)keys;

- (void)moveSectionFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx;

- (NSUInteger)sectionIdxForKey:(NSString *)key;

// row
- (ZBFancyItem *)rowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<ZBFancyItem *> *)rawsForSectionIdx:(NSUInteger)sectionIdx;

- (NSString *)protoTypeAtIndexPath:(NSIndexPath *)indexPath;

- (id)rawModelAtIndexPath:(NSIndexPath *)indexPath;

@end
