//
//  UIImage+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "UIImage+Ethanol.h"

typedef enum {
  ALPHA = 0,
  BLUE = 1,
  GREEN = 2,
  RED = 3
} PIXELS;

@implementation UIImage (Ethanol)

- (UIImage *)eth_overlayWithColor:(UIColor *)color {
  return [self eth_overlayWithColor:color blendMode:kCGBlendModeOverlay];
}

- (UIImage *)eth_overlayWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
  // From https://robots.thoughtbot.com/designing-for-ios-blending-modes
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  [color setFill];
  CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
  UIRectFill(bounds);
  [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
  
  if (blendMode != kCGBlendModeDestinationIn) {
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
  }
  
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return tintedImage;
}

- (UIImage *)eth_overlayWithImage:(UIImage *)image {
  return [self eth_overlayWithImage:image blendMode:kCGBlendModeNormal];
}

- (UIImage *)eth_overlayWithImage:(UIImage *)image blendMode:(CGBlendMode)blendMode {
  CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0.0f, rect.size.height);
  CGContextScaleCTM(context, 1.0f, -1.0f);
  CGContextDrawImage(context, rect, self.CGImage);
  CGContextSetBlendMode(context, blendMode);
  CGContextDrawImage(context, rect, image.CGImage);
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

- (UIColor *)eth_colorAtPoint:(CGPoint)point {
  CGSize size = self.size;
  CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
  if (!CGRectContainsPoint(rect, point)) return nil;
  
  NSInteger pointX = trunc(point.x);
  NSInteger pointY = trunc(point.y);
  
  CGImageRef image = self.CGImage;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char pixel[4] = {0, 0, 0, 0};
  
  CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  
  CGContextSetBlendMode(context, kCGBlendModeCopy);
  CGContextTranslateCTM(context, -pointX, pointY - size.height + 1);
  CGContextDrawImage(context, rect, image);
  CGContextRelease(context);
  
  CGFloat red   = pixel[0] / 255.0f;
  CGFloat green = pixel[1] / 255.0f;
  CGFloat blue  = pixel[2] / 255.0f;
  CGFloat alpha = pixel[3] / 255.0f;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)eth_grayscaleImage {
  CGFloat scale = [[UIScreen mainScreen] scale];
  
  CGSize size = [self size];
  int width = size.width *scale;
  int height = size.height *scale;
  
  // the pixels will be painted to this array
  uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
  
  // clear the pixels so any transparency is preserved
  memset(pixels, 0, width * height * sizeof(uint32_t));
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  // create a context with RGBA pixels
  CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                               kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
  
  // paint the bitmap to our context which will fill in the pixels array
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
  
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
      
      // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
      float redConstant = 0.2126;
      float greenConstant = 0.7152;
      float blueConstant = 0.0722;
      uint32_t gray = redConstant * rgbaPixel[RED] + greenConstant * rgbaPixel[GREEN] + blueConstant * rgbaPixel[BLUE];
      
      // set the pixels to gray
      rgbaPixel[RED] = gray;
      rgbaPixel[GREEN] = gray;
      rgbaPixel[BLUE] = gray;
    }
  }
  
  // create a new CGImageRef from our context with the modified pixels
  CGImageRef image = CGBitmapContextCreateImage(context);
  
  // we're done with the context, color space, and pixels
  CGContextRelease(context);
  CGColorSpaceRelease(colorSpace);
  free(pixels);
  
  // make a new UIImage to return
  UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
  
  // we're done with image now too
  CGImageRelease(image);
  
  return resultUIImage;
}

- (UIImage *)eth_cropToRect:(CGRect)rect {
  CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
  UIImage * finalImage = [[UIImage alloc]initWithCGImage:imageRef];
  CGImageRelease(imageRef);
  return finalImage;
}

- (UIImage *)eth_cropToCircle {
  return [self eth_cropToCircleWithRadius:MIN(self.size.width, self.size.height)/2];
}

- (UIImage *)eth_cropToCircleWithRadius:(float)radius {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //Calculate the centre of the circle
  CGFloat imageCentreX = self.size.width / 2;
  CGFloat imageCentreY = self.size.height / 2;
  
  // Create and CLIP to a CIRCULAR Path
  // (This could be replaced with any closed path if you want a different shaped clip)
  CGContextBeginPath (context);
  CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
  CGContextClosePath (context);
  CGContextClip (context);
  
  CGRect positionRect = CGRectMake(0, 0, self.size.width, self.size.height);
  [self drawInRect:positionRect];
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

- (UIImage *)eth_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
  BOOL drawTransposed;
  
  switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      drawTransposed = YES;
      break;
      
    default:
      drawTransposed = NO;
  }
  
  return [self eth_resizedImage:newSize
                  transform:[self eth_transformForOrientation:newSize]
             drawTransposed:drawTransposed
       interpolationQuality:quality];
}

- (UIImage *)eth_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                          bounds:(CGSize)bounds
                            interpolationQuality:(CGInterpolationQuality)quality {
  CGFloat horizontalRatio = bounds.width / self.size.width;
  CGFloat verticalRatio = bounds.height / self.size.height;
  CGFloat ratio;
  
  switch (contentMode) {
    case UIViewContentModeScaleAspectFill:
      ratio = MAX(horizontalRatio, verticalRatio);
      break;
      
    case UIViewContentModeScaleAspectFit:
      ratio = MIN(horizontalRatio, verticalRatio);
      break;
      
    default:
      [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (unsigned long)contentMode];
  }
  
  CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
  
  return [self eth_resizedImage:newSize interpolationQuality:quality];
}

#pragma mark - Private Helpers

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: BjÃ¶rn SÃ¥llarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)eth_addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
  if (ovalWidth == 0 || ovalHeight == 0) {
    CGContextAddRect(context, rect);
    return;
  }
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM(context, ovalWidth, ovalHeight);
  CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
  CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
  CGContextMoveToPoint(context, fw, fh/2);
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

- (UIImage *)eth_resizedImage:(CGSize)newSize
                        transform:(CGAffineTransform)transform
                   drawTransposed:(BOOL)transpose
             interpolationQuality:(CGInterpolationQuality)quality {
  CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
  CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
  CGImageRef imageRef = self.CGImage;
  
  // Build a context that's the same dimensions as the new size
  CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                              newRect.size.width,
                                              newRect.size.height,
                                              CGImageGetBitsPerComponent(imageRef),
                                              0,
                                              CGImageGetColorSpace(imageRef),
                                              CGImageGetBitmapInfo(imageRef));
  
  // Rotate and/or flip the image if required by its orientation
  CGContextConcatCTM(bitmap, transform);
  
  // Set the quality level to use when rescaling
  CGContextSetInterpolationQuality(bitmap, quality);
  
  // Draw into the context; this scales the image
  CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
  
  // Get the resized image from the context and a UIImage
  CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
  UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
  
  // Clean up
  CGContextRelease(bitmap);
  CGImageRelease(newImageRef);
  
  return newImage;
}

- (CGAffineTransform)eth_transformForOrientation:(CGSize)newSize {
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (self.imageOrientation) {
    case UIImageOrientationDown:           // EXIF = 3
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:           // EXIF = 6
    case UIImageOrientationLeftMirrored:   // EXIF = 5
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:          // EXIF = 8
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, 0, newSize.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
      
    default:
      break; // Prevents warning
  }
  
  switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:     // EXIF = 2
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:   // EXIF = 5
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, newSize.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    default:
      break; // Prevents warning
  }
  
  return transform;
}

@end
