//
//  CADisplayLink+EthanolBlocks.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
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

#import <objc/runtime.h>
#import "CADisplayLink+EthanolBlocks.h"

static char kDisplayLinkBlockKey;

@implementation CADisplayLink (EthanolBlocks)

+ (CADisplayLink *)eth_displayLinkWithBlock:(ETHDisplayLinkTriggeredBlock)block {
  objc_setAssociatedObject(self, &kDisplayLinkBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
  return [self displayLinkWithTarget:self selector:@selector(eth_displayLinkTriggered:)];
}

+ (void)eth_displayLinkTriggered:(CADisplayLink *)displayLink {
  ETHDisplayLinkTriggeredBlock block = objc_getAssociatedObject(self, &kDisplayLinkBlockKey);
  if(block != nil) {
    block(displayLink);
  } else {
    [displayLink invalidate];
  }
}

@end
