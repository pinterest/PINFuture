//
//  PINExecutor.h
//  Pods
//
//  Created by Chris Danford on 12/7/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PINExecutor
- (void)execute:(dispatch_block_t)block;
@end

@interface PINExecutor : NSObject <PINExecutor>

/**
 * Can't be created.  This exists only for class methods.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Executes immediately on whatever the current thread is without trampolining.
 */
+ (id<PINExecutor>)immediate;

/**
 * Disaptches on a specified queue.
 */
+ (id<PINExecutor>)queue:(dispatch_queue_t)queue;

/**
 * Disaptches to main thread queue.
 */
+ (id<PINExecutor>)mainQueue;

/**
 * Disaptches to background queue.
 */
+ (id<PINExecutor>)background;

@end

NS_ASSUME_NONNULL_END
