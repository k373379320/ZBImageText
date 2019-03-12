//
//  ZBFancyCellProtocol.h
//  ZBFancyCollectionView
//
//  Created by xzb on 2018/8/1.
//

#import <Foundation/Foundation.h>

@protocol ZBFancyCellProtocol <NSObject>

@required

- (void)loadData:(id)data;

@optional
+ (CGSize)itemSize:(id)data;
/**
 只支持top,left
 */
+ (UIEdgeInsets)itemMargin:(id)data;

@end
