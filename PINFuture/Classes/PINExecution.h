//
//  PINExecution.h
//  Pods
//
//  Created by Chris Danford on 12/7/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A context that takes a block and returns a new block that executes the original block in some context.
 */
typedef dispatch_block_t (^PINExecutionContext)(dispatch_block_t);

/**
 * A function evaluated at the time a callback is registered.  It returns an execution context.
 */
typedef PINExecutionContext (*PINThreadingModel)();

//@protocol PINExecution
//- (void)dispatch:(dispatch_block_t)block;
//@end

@interface PINExecution : NSObject

/**
 * Can't be created.  This exists only for class methods.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * When a PINExecutionContext isn't specified by the caller, this should be called to get the default value.
 * Careful: the return value depends on the current thread.
 */
+ (PINExecutionContext)defaultContextForCurrentThread;

// TODO: If there's demand, enable and test this.
//+ (void)setDefaultThreadingModel:(PINThreadingModel)threadingModel;

/**
 * Executes immediately on whatever the current thread is without trampolining.
 */
+ (PINExecutionContext)immediate;

/**
 * Disaptches on a specified queue.
 */
+ (PINExecutionContext)queue:(dispatch_queue_t)queue;

/**
 * Disaptches to main thread queue.
 */
+ (PINExecutionContext)mainQueue;

/**
 * Disaptches to background queue.
 */
+ (PINExecutionContext)background;

@end

NS_ASSUME_NONNULL_END
