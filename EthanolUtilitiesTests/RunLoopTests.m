//
//  RunLoopTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
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
