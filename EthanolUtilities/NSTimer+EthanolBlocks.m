//
//  NSTimer+EthanolBlocks.m
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
