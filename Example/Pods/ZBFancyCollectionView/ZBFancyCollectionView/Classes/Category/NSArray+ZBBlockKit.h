//
//  NSArray+ZBBlockKit.h
//  ZBFancyCollectionView
//
//  Created by xzb on 2018/8/1.
//

#import <Foundation/Foundation.h>


extern CGSize ZBGetSizeSendMsg(id target, SEL selector, id model);
extern UIEdgeInsets ZBGetEdgeInsetsSendMsg(id target, SEL selector, id model);


@interface NSArray (ZBBlockKit)

- (void)zbbk_each:(void (^)(id obj))block;

- (NSArray *)zbbk_map:(id (^)(id obj))block;

@end
