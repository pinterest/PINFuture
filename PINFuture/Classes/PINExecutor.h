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
 * Executes immediately if the executor is invoked from the Main thread.  If the executor is not invoked from the Main thread
 * then uses `mainQueue`.  Use this instead of `[PINExecutor mainQueue]` only if you know what you're doing and are looking to
 * reduce the number of dispatches to the Main queue.
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

/**
 * Disaptches to Main queue.
 */
+ (id<PINExecutor>)mainQueue;

@end

NS_ASSUME_NONNULL_END
