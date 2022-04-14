//
//  PINFutureDefinition.h
//  Copyright © 2022-present, Pinterest, Inc. All rights reserved.
//

#ifndef PINFutureDefinition_h
#define PINFutureDefinition_h

#import <PINFuture/PINExecutor.h>
#import <PINFuture/PINDefines.h>

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
@interface PINFuture<__covariant ObjectType> : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Return a future that is immediately resolved.
 */
+ (PINFuture<ObjectType> *)withValue:(ObjectType)value PIN_WARN_UNUSED_RESULT;

/**
 * Return a future that is immediately rejected.
 */
+ (PINFuture<ObjectType> *)withError:(NSError *)error PIN_WARN_UNUSED_RESULT;

/**
 * Construct a future from a block that eventually calls resolve or reject.
 * This is slightly dangerous and should only be used when adapting from callbacks to a Future because there's no compiler enforcement
 * that all paths of your block will eventually call either `resolve` or `reject`.
 */
+ (PINFuture<ObjectType> *)withBlock:(void(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block PIN_WARN_UNUSED_RESULT;

#pragma mark - attach callbacks

/**
 * Execute a block on success or on failure.  Use this if you want to have a side-effect and nothing
 * needs to wait on your side-effect to complete.
 */
- (void)executor:(id<PINExecutor>)executor success:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END


#endif /* PINFutureDefinition_h */
