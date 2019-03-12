//
//  ZBSection.m
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import "ZBSection.h"

@interface ZBSection ()
@property (nonatomic, strong, readwrite) NSMutableArray<__kindof ZBFancyItem *> *innerRows;
@end

@implementation ZBSection

- (NSArray<__kindof ZBFancyItem *> *)rows
{
    return [self.innerRows copy];
}

- (ZBFancyItem *)rowAtIdx:(NSInteger)idx
{
    if (self.innerRows.count > idx) {
        return self.innerRows[idx];
    }
    return nil;
}

- (void)appendRows:(NSArray<__kindof ZBFancyItem *> *)rows
{
    [self.innerRows addObjectsFromArray:rows];
}

- (void)insertRows:(NSArray<__kindof ZBFancyItem *> *)rows atIdx:(NSUInteger)idx
{
    if (rows.count > 0) {
        NSInteger index = self.innerRows.count > idx ? idx : self.innerRows.count;
        [rows enumerateObjectsUsingBlock:^(__kindof ZBFancyItem *obj, NSUInteger i, BOOL *stop) {
            [self.innerRows insertObject:obj atIndex:(index + i)];
        }];
    }
}

- (void)deleteRowsForIdxs:(NSArray<NSNumber *> *)idxs
{
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    [idxs enumerateObjectsUsingBlock:^(NSNumber *i, NSUInteger idx, BOOL *stop) {
        if (self.innerRows.count > i.unsignedIntegerValue) {
            [deleteIndexSet addIndex:i.unsignedIntegerValue];
        }
    }];
    [self.innerRows removeObjectsAtIndexes:deleteIndexSet];
}

- (void)moveRowFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx
{
    if (self.innerRows.count > fromIdx && self.innerRows.count > toIdx && fromIdx != toIdx) {
        ZBFancyItem *rowData = self.innerRows[fromIdx];
        [self.innerRows removeObjectAtIndex:fromIdx];
        [self.innerRows insertObject:rowData atIndex:(fromIdx > toIdx ? toIdx : (toIdx - 1))];
    }
}

- (void)replaceSectionWithRows:(NSArray<__kindof ZBFancyItem *> *)rows
{
    self.innerRows = [[NSMutableArray alloc] initWithArray:rows];
}

ZBLazyProperty(NSMutableArray, innerRows);
@end
