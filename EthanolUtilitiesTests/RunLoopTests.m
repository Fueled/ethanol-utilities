//
//  RunLoopTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
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

#import <XCTest/XCTest.h>
#import "CADisplayLink+EthanolBlocks.h"
#import "NSTimer+EthanolBlocks.h"

@interface RunLoopTests : XCTestCase

@end

@implementation RunLoopTests

- (void)testTimerWithBlock {
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:0.6];
  __block BOOL timerFired = NO;
  
  [NSTimer eth_scheduledTimerWithTimeInterval:0.5 block:^(NSTimer *timer) {
    timerFired = YES;
  }];
  
  while(!timerFired && [timeoutDate timeIntervalSinceNow] > 0) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
  }
  
  if(!timerFired) {
    XCTFail(@"Test timed out");
  }
}

- (void)testTimerWithNilBlock {
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:0.6];
  __block BOOL timerFired = NO;
  
  NSTimer * timer = [NSTimer eth_scheduledTimerWithTimeInterval:0.5 block:nil];
  
  while(!timerFired && [timeoutDate timeIntervalSinceNow] > 0) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
  }
  
  XCTAssertFalse(timer.valid);
}

@end
