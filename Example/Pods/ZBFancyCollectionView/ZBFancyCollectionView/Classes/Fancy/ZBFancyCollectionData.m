//
//  ZBTableData.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBFancyCollectionData.h"
#import "ZBSection.h"
#import "ZBFancyItem.h"

@interface ZBFancyCollectionData ()

@property (nonatomic, strong) NSMutableArray<__kindof ZBSection *> *innerSections;

@end

@implementation ZBFancyCollectionData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _innerSections = [@[] mutableCopy];
    }
    return self;
}

- (NSArray<NSString *> *)allSectionsKeys
{
    return [self.innerSections zbbk_map:^id (ZBSection *section) {
        return section.key;
    }];
}

- (NSArray<ZBSection *> *)sections
{
    return [self.innerSections copy];
}

- (ZBSection *)sectionAtIdx:(NSInteger)idx
{
    if (self.innerSections.count > idx) {
        return self.innerSections[idx];
    }
    return nil;
}

- (ZBSection *)sectionForKey:(NSString *)key
{
    NSUInteger index = [[self allSectionsKeys] indexOfObject:key];
    if (index != NSNotFound && self.innerSections.count > index) {
        return self.innerSections[index];
    }
    return nil;
}

- (void)resetWithSections:(NSArray<ZBSection *> *)sections
{
    self.innerSections = [sections mutableCopy];
}

- (void)replaceSection:(ZBSection *)section newSection:(ZBSection *)newSection
{
    NSUInteger index = [[self allSectionsKeys] indexOfObject:section.key];
    if (index != NSNotFound) {
        [self.innerSections replaceObjectAtIndex:index withObject:newSection];
    }
}

- (void)appendSections:(NSArray<ZBSection *> *)sections
{
    [self.innerSections addObjectsFromArray:sections];
}

- (void)insertSections:(NSArray<ZBSection *> *)sections atIdx:(NSUInteger)idx
{
    if (sections.count > 0) {
        NSInteger index = self.innerSections.count > idx ? idx : self.innerSections.count;
        [sections enumerateObjectsUsingBlock:^(__kindof ZBSection *obj, NSUInteger i, BOOL *stop) {
            [self.innerSections insertObject:obj atIndex:(index + i)];
        }];
    }
}

- (void)deleteSectionsForIdxs:(NSArray<NSNumber *> *)idxs
{
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    [idxs enumerateObjectsUsingBlock:^(NSNumber *i, NSUInteger idx, BOOL *stop) {
        if (self.innerSections.count > i.unsignedIntegerValue) {
            [deleteIndexSet addIndex:i.unsignedIntegerValue];
        }
    }];
    [self.innerSections removeObjectsAtIndexes:deleteIndexSet];
}

- (void)deleteSectionsForKeys:(NSArray<NSString *> *)keys
{
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    NSArray *allSectionsKeys = [self allSectionsKeys];
    [keys enumerateObjectsUsingBlock:^(NSString *identifier, NSUInteger idx, BOOL *stop) {
        if ([allSectionsKeys containsObject:identifier]) {
            [deleteIndexSet addIndex:[allSectionsKeys indexOfObject:identifier]];
        }
    }];
    [self.innerSections removeObjectsAtIndexes:deleteIndexSet];
}

- (void)moveSectionFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx
{
    if (self.innerSections.count > fromIdx && self.innerSections.count > toIdx && fromIdx != toIdx) {
        ZBSection *sectionData = self.innerSections[fromIdx];
        [self.innerSections removeObjectAtIndex:fromIdx];
        [self.innerSections insertObject:sectionData atIndex:(fromIdx > toIdx ? toIdx : (toIdx - 1))];
    }
}

- (NSUInteger)sectionIdxForKey:(NSString *)key
{
    return [[self allSectionsKeys] indexOfObject:key];
}

- (ZBFancyItem *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBSection *section = [self sectionAtIdx:indexPath.section];
    return [section rowAtIdx:indexPath.row];
}

- (NSArray<ZBFancyItem *> *)rawsForSectionIdx:(NSUInteger)sectionIdx
{
    if (self.innerSections.count > sectionIdx) {
        ZBSection *sectionData = self.innerSections[sectionIdx];
        return sectionData.rows;
    }
    return nil;
}

- (NSString *)protoTypeAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancyItem *row = [self rowAtIndexPath:indexPath];
    return row.protoType;
}

- (id)rawModelAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancyItem *row = [self rowAtIndexPath:indexPath];
    return row.rawModel;
}

@end
