//
//  PINFuture.h
//  Pinterest
//
//  Created by Chris Danford on 11/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PINExecutor.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A super-simple future implementation.
 * This is a pure objective C implementation that:
 * - is thread-safe
 * - preserves type safety as much as possible
 *
 * Non-goals:
 * - Don't catch Exceptions in callbacks like Promises/A+.  On this platform, Exceptions are generally fatal
 *   and Errors aren't.
 *
 * Future improvement ideas:
 * - Support progress and cancellation.
 */
@interface PINFuture<ObjectType> : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Return a future that is immediately resolved.
 */
+ (PINFuture<ObjectType> *)withValue:(ObjectType)value;

/**
 * Return a future that is immediately rejected.
 */
+ (PINFuture<ObjectType> *)withError:(NSError *)error;

/**
 * Construct a future from a block that eventually calls resolve or reject.
 * This is slightly dangerous and should only be used when adapting from callbacks to a Future because there's no compiler enforcement
 * that all paths of your block will eventually call either `resolve` or `reject`.
 */
+ (PINFuture<ObjectType> *)withBlock:(void(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block;

#pragma mark - attach callbacks

- (void)executor:(id<PINExecutor>)executor completion:(void(^)(NSError *error, ObjectType value))completion;

@end

@interface PINFuture<ObjectType> (Convenience)

#pragma mark - callback methods that specify an execution context

- (void)executor:(id<PINExecutor>)executor success:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

#pragma mark - callback methods that don't specify an execution context

- (void)completion:(void(^)(NSError *error, ObjectType value))completion;
- (void)success:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

#pragma mark - misc

/**
 * Return a new future that strips out the resolved value but passes through any error.
 * Use this if you have a future but don't want to expose its value.
 */
- (PINFuture<NSNull *> *)mapToNull;

@end

NS_ASSUME_NONNULL_END

// Import everything for caller convenience.
#import "PINFuture+All.h"
#import "PINFuture+Dispatch.h"
#import "PINFuture+FlatMapError.h"
#import "PINFuture+MapError.h"
#import "PINFuture2.h"
#import "PINFuture2+Map.h"
#import "PINFuture2+FlatMap.h"
