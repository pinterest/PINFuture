//
//  PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/12/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecution.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> : NSObject

typedef dispatch_block_t PINCancellationBlock;

typedef __nullable PINCancellationBlock (^PINComputationBlock)(void(^resolve)(ObjectType), void(^reject)(NSError *));

#pragma mark - constructors
/**
 * Computation is a function that accepts two callbacks. It should call one of them after completion with the final result (success or failure).
 * Also a computation may return a CancellationBlock with cancellation logic or it can return undefined if there is no cancellation logic
 */
+ (PINTask<ObjectType> *)new:(__nullable PINCancellationBlock(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block;
+ (PINTask<ObjectType> *)value:(ObjectType)value;
+ (PINTask<ObjectType> *)error:(NSError *)error;

//- (PINTask<ObjectType> *)retry:(NSUInteger)numRetries initialDelay:(NSTimeInterval)delay exponent:(float)exponent;
//- (PINTask<ObjectType> *)fork:(PINExecutionContext)context;
- (PINTask<ObjectType> *)cache;
//- (PINTask<ObjectType> *)mapError:(NSError *(^)(NSError *error))mapError;
//- (PINTask<ObjectType> *)flatMapError:(PINTask<ObjectType> *(^)(NSError *error))flatMapError;
@end

@interface PINTask<ObjectType> (Convenience)
//- (__nullable PINCancellationBlock)runAsyncContext:(PINExecutionContext)context success:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (__nullable PINCancellationBlock)runAsyncSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (__nullable PINCancellationBlock)runAsyncCompletion:(void(^)(NSError *error, ObjectType value))completion;
@end

@interface PINTask2<FromType, ToType> : NSObject
//+ (PINTask<ToType> *)map:(PINTask<FromType> *)task success:(ToType (^)(FromType fromValue))success;
//+ (PINTask<ToType> *)flatMap:(PINTask<FromType> *)task success:(PINTask<ToType> * (^)(FromType fromValue))success;
@end

NS_ASSUME_NONNULL_END
