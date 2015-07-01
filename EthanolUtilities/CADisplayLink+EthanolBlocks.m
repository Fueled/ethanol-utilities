//
//  CADisplayLink+EthanolBlocks.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
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
