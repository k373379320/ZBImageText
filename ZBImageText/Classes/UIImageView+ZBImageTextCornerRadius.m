//
//  UIImageView+ZBImageTextCornerRadius.m
//  ZBImageText
//
//  Created by xzb on 2019/4/26.
//

#import "UIImageView+ZBImageTextCornerRadius.h"

@implementation UIImage (ZBImageTextCornerRadius)

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(contextRef,path.CGPath);
    CGContextClip(contextRef);
    [self drawInRect:rect];
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImageView (ZBImageTextCornerRadius)

- (void)zb_setCornerRadius:(CGFloat)cornerRadius
{
    self.image = [self.image imageAddCornerWithRadius:cornerRadius andSize:self.bounds.size];
}

@end
