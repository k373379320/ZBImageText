//
//  ZBImageTextMaker.h
//  ZBImageTextProject
//
//  Created by xzb on 2019/2/28.
//  Copyright © 2019 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZBImageText.h"

typedef void(^ZBImageTextBlock)(id obj);
typedef void(^YYTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);


@interface ZBImageTextMaker : NSObject

- (void (^)(CGFloat))space;

- (ZBImageTextItemImage * (^)(UIImage *image))image;

- (ZBImageTextItemText * (^)(NSString *text))text;

- (NSAttributedString *)install;

- (void)setupGlobalConfig:(NSDictionary *)config;

@end
