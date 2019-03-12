//
//  ZBCollectionMaker.h
//  XZBProduct
//
//  Created by xzb on 2018/7/23.
//  Copyright © 2018年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBSection.h"
#import "ZBFancyItem.h"

@interface ZBCollectionViewSectionMaker : NSObject

@property (nonatomic, strong) ZBSection *section;

@end

@interface ZBCollectionRowMaker : NSObject

@property (nonatomic, strong) ZBFancyItem *row;

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^itemSize)(CGSize size);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^model)(id model);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^tag)(NSString *tag);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^configureSEL)(SEL selector);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^itemSizeSEL)(SEL selector);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^constructBlock)(UICollectionViewCell * (^)(id));

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^selectBlock)(void (^)(id));

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^configureBlock)(void (^)(id));

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^extraDictBlock)(NSDictionary *extraDict);

@property (nonatomic, copy, readonly) ZBCollectionRowMaker * (^bundle)(NSBundle *bundle);

@end

@interface ZBCollectionMaker : NSObject

@property (nonatomic, copy) ZBCollectionViewSectionMaker * (^section)(NSString *key);

@property (nonatomic, copy) ZBCollectionRowMaker * (^sectionHeader)(NSString *proto);

@property (nonatomic, copy) ZBCollectionRowMaker * (^sectionFooter)(NSString *proto);

@property (nonatomic, copy) ZBCollectionRowMaker * (^row)(NSString *proto);

- (NSArray *)install;

@end
