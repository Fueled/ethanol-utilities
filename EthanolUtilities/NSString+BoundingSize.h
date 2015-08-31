//
//  NSString+BoundingSize.h
//  Ethanol
//
//  Created by Stephane Copin on 5/15/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPUTE_BOUND 0.0f

@interface NSString (BoundingSize)

- (CGSize)eth_boundingSizeWithSize:(UIFont *)font;
- (CGSize)eth_boundingSizeWithSize:(CGSize)eth_size font:(UIFont *)font;
- (CGSize)eth_boundingSizeWithSize:(CGSize)eth_size font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignement;

- (CGSize)boundingSizeWithSize:(UIFont *)font __deprecated_msg("Please use the eth_ prefixed method instead");
- (CGSize)boundingSizeWithSize:(CGSize)size font:(UIFont *)font __deprecated_msg("Please use the eth_ prefixed method instead");
- (CGSize)boundingSizeWithSize:(CGSize)size font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignement __deprecated_msg("Please use the eth_ prefixed method instead");

@end
