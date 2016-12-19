//
//  PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/12/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecution.h"
#import "PINPair.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> : NSObject

typedef dispatch_block_t PINCancellationBlock;

typedef __nullable PINCancellationBlock (^PINComputationBlock)(void(^resolve)(ObjectType), void(^reject)(NSError *));

#pragma mark - constructors
/**
 * Computation is a function that accepts two callbacks. It should call one of them after completion with the final result (success or failure).
 * Also a computation may return a CancellationBlock with cancellation logic or it can return undefined if there is no cancellation logic
 */
+ (PINTask<ObjectType> *)new:(__nullable PINCancellationBlock(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block __attribute__((warn_unused_result));
+ (PINTask<ObjectType> *)value:(ObjectType)value __attribute__((warn_unused_result));
+ (PINTask<ObjectType> *)error:(NSError *)error __attribute__((warn_unused_result));

- (PINTask<ObjectType> *)doSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure __attribute__((warn_unused_result));
- (__nullable PINCancellationBlock)run;

@end

@interface PINTask<ObjectType> (Convenience)
//- (__nullable PINCancellationBlock)doCompletion:(void(^)(NSError *error, ObjectType value))completion;
//- (__nullable PINCancellationBlock)runAsyncContext:(PINExecutionContext)context success:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
//- (__nullable PINCancellationBlock)runAsyncSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
//- (__nullable PINCancellationBlock)runAsyncCompletion:(void(^)(NSError *error, ObjectType value))completion;
@end

@interface PINTask<ObjectType> (Compose)
//- (PINTask<ObjectType> *)retry:(NSUInteger)numRetries initialDelay:(NSTimeInterval)delay exponent:(float)exponent;
//- (PINTask<ObjectType> *)mapError:(NSError *(^)(NSError *error))mapError;
//- (PINTask<ObjectType> *)flatMapError:(PINTask<ObjectType> *(^)(NSError *error))flatMapError;
- (PINTask<NSNull *> *)mapToNull __attribute__((warn_unused_result));
@end

NS_ASSUME_NONNULL_END

// Import everything for caller convenience.
#import "PINTask+All.h"
#import "PINTask+Cache.h"
#import "PINTask+Dispatch.h"
#import "PINTask+Do.h"
//#import "PINTask+FlatMapError.h"
//#import "PINTask+MapError.h"
#import "PINTask2.h"
#import "PINTask2+Map.h"
#import "PINTask2+FlatMap.h"
