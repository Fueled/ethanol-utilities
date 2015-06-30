//
//  NSTimer+EthanolBlocks.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ ETHTimerTriggeredBlock)(NSTimer * timer);

@interface NSTimer (EthanolBlocks)

+ (NSTimer *)eth_timerWithTimeInterval:(NSTimeInterval)ti block:(ETHTimerTriggeredBlock)block repeats:(BOOL)repeats;

@end
