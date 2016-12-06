//
//  PINFuture.h
//  Pinterest
//
//  Created by Chris Danford on 11/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A super-simple future implementation.
 * This is a pure objective C implemtnation that:
 * - is thread-safe
 * - preserves type safety in callbacks as much as possible
 * - Doesn't always defer callbacks to the next runloop tick.
 * - Does not support "thenable" the concept of then-ables or wrapping of values returned from a `then` callback
 *   into a Future.  I haven't been able to find a good value to model this with Objective C's type system, and
 *   the convenience isn't worth the loss of type safety.
 * - does not have any automatic exception catching
 *
 * Future improvement ideas:
 * - Support progress and cancellation.
 */
@interface PINFuture<ObjectType> : NSObject

/**
 * Return a future that is immediately resolved.
 */
+ (PINFuture<ObjectType> *)futureWithValue:(ObjectType)value;

/**
 * Return a future that is immediately rejected.
 */
+ (PINFuture<ObjectType> *)futureWithError:(NSError *)error;

/**
 * Adapt from callbacks to a future.
 */
+ (PINFuture<ObjectType> *)futureWithBlock:(void(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block;

#pragma mark - attach callbacks

- (void)queue:(dispatch_queue_t)queue completion:(void(^)(NSError *error, ObjectType value))completion;

@end

@interface PINFuture<ObjectType> (Convenience)

/**
 * A future that immediately resolves with a value of no significance.  This is often useful inside of a `then` callback.
 */
+ (PINFuture<NSNull *> *)futureWithNull;

- (void)queue:(dispatch_queue_t)queue success:(void(^)(ObjectType value))success failure:(void(^)(NSError *error))failure;
- (void)queue:(dispatch_queue_t)queue success:(void(^)(ObjectType value))success;

#pragma mark - callback methods that smartly dispatch either to Main or the default global queue depending on whether they are called from Main.

- (void)completion:(void(^)(NSError *error, ObjectType value))completion;
- (void)success:(void(^)(ObjectType value))success failure:(void(^)(NSError *error))failure;
- (void)success:(void(^)(ObjectType value))success;

@end

NS_ASSUME_NONNULL_END

// Import everything for caller convenience.
#import "PINFuture+Dispatch.h"
#import "PINFuture+Util.h"
#import "PINThen.h"
