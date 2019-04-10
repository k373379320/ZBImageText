//
//  ZBImageTextUtilities.h
//  ZBImageText
//
//  Created by xzb on 2019/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBImageTextUtilities : NSObject

+ (UIImage *)highQualityImageWithOriginalImage:(UIImage *)image;
+ (void)getAsyncHighQualityImageWithOriginalImage:(UIImage *)image complate:(void(^)(UIImage *image))complate;
- (UIImage *)imageScaledOriImage:(UIImage *)image toSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
