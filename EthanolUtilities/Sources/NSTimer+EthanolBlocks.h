//
//  NSTimer+EthanolBlocks.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EthanolUtilities/ETHpreprocessorUtils.h>

typedef void (^ ETHTimerTriggeredBlock)(NSTimer * timer);

@interface NSTimer (EthanolBlocks)

// These timer can't be made to repeat to enforce using a selector when using a repeatable timer.
// A repeatable timer using a block will, if it's made to always be running, create a retain-cycle
// because NSTimer retain the target.
+ (NSTimer *)eth_timerWithTimeInterval:(NSTimeInterval)ti block:(ETHTimerTriggeredBlock)block ETH_NEW_METHOD;
+ (NSTimer *)eth_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(ETHTimerTriggeredBlock)block;

@end
