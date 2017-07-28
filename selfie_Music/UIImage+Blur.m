//
//  UIImage+Blur.m
//  selfie_music
//
//  Created by imbc on 2017. 5. 29..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage(blur)

-(UIImage*)blur:(UIImage *)targetImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *tempImage = [targetImage copy];
    CIImage *inputImage = [CIImage imageWithCGImage:tempImage.CGImage];
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:kCIInputImageKey];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    CIImage *clampImage = [clampFilter outputImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setDefaults];
    [filter setValue:clampImage forKey:kCIInputImageKey];
    [filter setValue:@(15.0f) forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage scale:tempImage.scale orientation:tempImage.imageOrientation];
    CGImageRelease(cgImage);

    return blurImage;

}

@end
