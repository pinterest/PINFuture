//
//  PINFuture.h
//  Pinterest
//
//  Created by Chris Danford on 11/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PINExecution.h"

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

- (void)context:(PINExecutionContext)context completion:(void(^)(NSError *error, ObjectType value))completion;

@end

@interface PINFuture<ObjectType> (Convenience)

#pragma mark - callback methods that specify an execution context

- (void)context:(PINExecutionContext)context success:(void(^)(ObjectType value))success failure:(void(^)(NSError *error))failure;
- (void)context:(PINExecutionContext)context success:(void(^)(ObjectType value))success;
- (void)context:(PINExecutionContext)context failure:(void(^)(NSError *error))failure;

#pragma mark - callback methods that don't specify an execution context

- (void)completion:(void(^)(NSError *error, ObjectType value))completion;
- (void)success:(void(^)(ObjectType value))success failure:(void(^)(NSError *error))failure;
- (void)success:(void(^)(ObjectType value))success;
- (void)failure:(void(^)(NSError *error))failure;

#pragma mark - misc

/**
 * Return a new future that strips out the resolved value but passes through any error.
 * Use this if you have a future but don't want to expose its value.
 */
- (PINFuture<NSNull *> *)mapToNull;

- (PINFuture<ObjectType> *)context:(PINExecutionContext)context recover:(PINFuture<ObjectType> *(^)(NSError *error))recover;

@end

NS_ASSUME_NONNULL_END

// Import everything for caller convenience.
#import "PINFuture+Dispatch.h"
#import "PINFuture+Util.h"
#import "PINFuture2.h"
#import "PINFuture2+Map.h"
#import "PINFuture2+FlatMap.h"
