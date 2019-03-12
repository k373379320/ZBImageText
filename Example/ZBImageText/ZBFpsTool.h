//
//  ZBFpsTool.h
//  ZBUitilty
//
//  Created by xzb on 2018/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBFpsTool : NSObject

+ (instancetype)instance;

- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler;

@end

NS_ASSUME_NONNULL_END
