//
//  NSString+BoundingSize.m
//  Ethanol
//
//  Created by Stephane Copin on 5/15/14.
//  Copyright (c) 2014 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSString+BoundingSize.h"

@import CoreText;

@implementation NSString (BoundingSize)

- (CGSize)eth_boundingSizeWithFont:(UIFont *)font {
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

@end
