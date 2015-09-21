//
//  UIImage+Ethanol.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ethanol)

/** Returns the image overlayed with the provided color using the normal blend mode.
 @param color The desired color to be painted over the image.
 @return The composited image.
 */
- (UIImage *)eth_overlayWithColor:(UIColor *)color;

/** Returns the image overlayed with the provided color and blend mode.
 @param color The desired color to be painted over the image.
 @param blendMode The blending mode to use.
 @return The composited image.
 */
- (UIImage *)eth_overlayWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;

/** Returns the image overlayed with the provided image using the normal blend mode.
 @param image The desired image to be placed over the image.
 @return The composited image.
 */
- (UIImage *)eth_overlayWithImage:(UIImage *)image;

/** Returns the image overlayed with the provided image and blend mode.
 @param image The desired image to be placed over the image.
 @param blendMode The blending mode to use.
 @return The composited image.
 */
- (UIImage *)eth_overlayWithImage:(UIImage *)image blendMode:(CGBlendMode)blendMode;

/** Returns the color information of the pixel at the provided point.
 @param point The pixel to inspect where (0,0) is considered the top left.
 @return A UIColor object representing the pixel.
 */
- (UIColor *)eth_colorAtPoint:(CGPoint)point;

- (UIImage *)eth_grayscaleImage;

- (UIImage *)eth_cropToRect:(CGRect)rect;

/**
 Crops the image to a circle with the same center as this image. The radius is half of the width/height (whichever is shorter).
 @returns A new image, cropped into a circle of the given radius.
 */
- (UIImage *)eth_cropToCircle;

/**
 Crops the image to a circle with the same center as this image, and the given radius.
 @param radius The radius of the cropping area.
 @returns A new image, cropped into a circle of the given radius.
 */
- (UIImage *)eth_cropToCircleWithRadius:(float)radius;

- (UIImage *)eth_resizedImage:(CGSize)newSize
             interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)eth_resizedImageWithContentMode:(UIViewContentMode)contentMode
																			bounds:(CGSize)bounds
												interpolationQuality:(CGInterpolationQuality)quality;

@end
