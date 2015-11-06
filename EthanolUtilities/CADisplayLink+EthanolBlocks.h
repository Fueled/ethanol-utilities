//
//  CADisplayLink+EthanolBlocks.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 4/26/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ETHpreprocessorUtils.h"

typedef void (^ ETHDisplayLinkTriggeredBlock)(CADisplayLink * displayLink);

@interface CADisplayLink (EthanolBlocks)

+ (CADisplayLink *)eth_displayLinkWithBlock:(ETHDisplayLinkTriggeredBlock)block ETH_NEW_METHOD;

@end
