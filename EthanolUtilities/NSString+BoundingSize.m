//
//  NSString+BoundingSize.m
//  Ethanol
//
//  Created by Stephane Copin on 5/15/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSString+BoundingSize.h"

@import CoreText;

@implementation NSString (BoundingSize)

- (CGSize)eth_boundingSizeWithSize:(UIFont *)font {
  return [self eth_boundingSizeWithSize:CGSizeMake(COMPUTE_BOUND, COMPUTE_BOUND) font:font];
}

- (CGSize)eth_boundingSizeWithSize:(CGSize)size font:(UIFont *)font {
  return [self eth_boundingSizeWithSize:size font:font textAlignment:NSTextAlignmentLeft];
}

- (CGSize)eth_boundingSizeWithSize:(CGSize)size font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignement {
  UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
  label.numberOfLines = 0;
  label.text = self;
  label.font = font;
  label.textAlignment = textAlignement;
  label.lineBreakMode = NSLineBreakByWordWrapping;
  [label sizeToFit];
  return CGSizeMake(label.frame.size.width, label.frame.size.height);
}

- (CGSize)boundingSizeWithSize:(UIFont *)font {
  return [self eth_boundingSizeWithSize:font];
}

- (CGSize)boundingSizeWithSize:(CGSize)size font:(UIFont *)font {
  return [self eth_boundingSizeWithSize:size font:font];
}

- (CGSize)boundingSizeWithSize:(CGSize)size font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignement {
  return [self eth_boundingSizeWithSize:size font:font textAlignment:textAlignement];
}

@end
