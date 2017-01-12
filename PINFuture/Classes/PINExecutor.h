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
 * Executes a block on the main thread.  The block is executed immediately if the executor is invoked from the Main thread.
 * If the executor is not invoked from the Main thread, then the block is dispatched to Main GCD queue.
 */
+ (id<PINExecutor>)main;

/**
 * Disaptches to background queue.
 */
+ (id<PINExecutor>)background;

/**
 * Executes immediately on whatever the current thread is without trampolining.
 * Use this as an optimization only if your block will execute extremely quickly, has no thread affinity
 * (because it could be executed from anywhere) and the cost of executing the block is low compared to
 * the cost of dispatching to a queue.
 */
+ (id<PINExecutor>)immediate;

/**
 * Disaptches on a specified queue.
 */
+ (id<PINExecutor>)queue:(dispatch_queue_t)queue;

@end

NS_ASSUME_NONNULL_END
