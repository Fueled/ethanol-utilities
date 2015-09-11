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

- (CGSize)eth_boundingSizeWithFont:(UIFont *)font;
- (CGSize)eth_boundingSizeWithSize:(CGSize)eth_size font:(UIFont *)font;
- (CGSize)eth_boundingSizeWithSize:(CGSize)eth_size font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignement;

@end
