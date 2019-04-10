//
//  ZBImageTextUtilities.m
//  ZBImageText
//
//  Created by xzb on 2019/3/19.
//

#import "ZBImageTextUtilities.h"
#import <ImageIO/ImageIO.h>
@implementation ZBImageTextUtilities

+ (UIImage *)highQualityImageWithOriginalImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (!imageData) {
        return nil;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFTypeRef)imageData, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, (CFDictionaryRef) @{ (id)kCGImageSourceShouldCache : @(NO) });
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);

    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(dataRef);
    CGImageRef newImageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
    UIImage *resultImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CFRelease(imageSourceRef);
    CFRelease(imageRef);
    CFRelease(dataRef);
    CFRelease(newProvider);
    CFRelease(newImageRef);
    return resultImage;
}

+ (void)getAsyncHighQualityImageWithOriginalImage:(UIImage *)image complate:(void (^)(UIImage *image))complate
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *resultImage = [[self class] highQualityImageWithOriginalImage:image];
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complate) {
                    complate(resultImage);
                }
            });
        } else {
            if (complate) {
                complate(nil);
            }
        }
    });
}

- (UIImage *)imageScaledOriImage:(UIImage *)image toSize:(CGSize)newSize
{
    if (!image) {
        return nil;
    }
    if (CGSizeEqualToSize(image.size, newSize)) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
