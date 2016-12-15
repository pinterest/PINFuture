//
//  PINOnce.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINOnce : NSObject
+ (instancetype)new;
- (void)performOnce:(dispatch_block_t)block;
@end
