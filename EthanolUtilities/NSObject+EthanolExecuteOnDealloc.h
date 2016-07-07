//
//  NSObject+EthanolExecuteOnDealloc.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/31/14.
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

#import <Foundation/Foundation.h>

typedef void (^ ETHPerformOnDeallocBlock)(id object);

@interface NSObject (EthanolExecuteOnDealloc)

/**
 *  Perform a block on when an object is dealloc'd.
 *  The object passed as an argument is the object that is being dealloc'd.
 *  This argument is unsafe_unretained, and it means that sending any messages to this object might crash.
 *  This is mainly useful to remove any observers this object may be attached to (KVO/NotificationCenter/etc)
 *
 *  @param deallocBlock Return block to execute on dealloc.
 */
- (void)eth_performBlockOnDealloc:(ETHPerformOnDeallocBlock)deallocBlock;

@end
