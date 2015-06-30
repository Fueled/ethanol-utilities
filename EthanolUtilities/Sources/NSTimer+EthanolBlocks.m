//
//  NSTimer+EthanolBlocks.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSTimer+EthanolBlocks.h"

@implementation NSTimer (EthanolBlocks)

+ (NSTimer *)eth_timerWithTimeInterval:(NSTimeInterval)ti block:(ETHTimerTriggeredBlock)block {
  return [NSTimer timerWithTimeInterval:ti target:self selector:@selector(eth_timerTriggered:) userInfo:block repeats:NO];
}

+ (NSTimer *)eth_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(ETHTimerTriggeredBlock)block {
  NSTimer * timer = [self eth_timerWithTimeInterval:ti block:block];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  return timer;
}

+ (void)eth_timerTriggered:(NSTimer *)timer {
  ETHTimerTriggeredBlock block = [timer userInfo];
  if(block != nil) {
    block(timer);
  } else {
    [timer invalidate];
  }
}

@end
