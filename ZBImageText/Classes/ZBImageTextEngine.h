//
//  ZBImageTextUtility.h
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/27.
//  Copyright © 2019 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBImageTextEngine : NSObject

+ (NSAttributedString *)attributedStringFromData:(NSArray<NSDictionary *> *)data;

@end

NS_ASSUME_NONNULL_END
