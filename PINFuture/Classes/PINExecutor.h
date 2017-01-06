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

///**
// * A context that takes a block and returns a new block that executes the original block in some context.
// */
//typedef _Nonnull dispatch_block_t (^PINExecutionContext)(dispatch_block_t);

/**
 * A function evaluated at the time a callback is registered.  It returns an execution context.
 * TODO(chris): Rip this out.  We've decided to make the execution context always explicit.
 */
typedef _Nonnull id<PINExecutor> (*PINThreadingModel)();

//@protocol PINExecution
//- (void)dispatch:(dispatch_block_t)block;
//@end

@interface PINExecutor : NSObject <PINExecutor>

/**
 * Can't be created.  This exists only for class methods.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * When a PINExecutionContext isn't specified by the caller, this should be called to get the default value.
 * Careful: the return value depends on the current thread.
 */
+ (id<PINExecutor>)defaultContextForCurrentThread;

// TODO: If there's demand, enable and test this.
//+ (void)setDefaultThreadingModel:(PINThreadingModel)threadingModel;

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
