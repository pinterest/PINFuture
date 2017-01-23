//
//  PINOnce.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PINDefines.h"

@interface PINOnce : NSObject
+ (instancetype)new PIN_WARN_UNUSED_RESULT;
- (void)performOnce:(dispatch_block_t)block;
@end
