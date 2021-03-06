//
//  UIImageView+ZBImageTextCornerRadius.h
//  ZBImageText
//
//  Created by xzb on 2019/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIImage (ZBImageTextCornerRadius)

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

@end
@interface UIImageView (ZBImageTextCornerRadius)

- (void)zb_setCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
