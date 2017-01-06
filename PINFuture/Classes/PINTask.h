//
//  PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/12/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINDefines.h"
#import "PINExecutor.h"
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
+ (PINTask<ObjectType> *)new:(__nullable PINCancellationBlock(^)(void(^resolve)(ObjectType), void(^reject)(NSError *)))block PIN_WARN_UNUSED_RESULT;
+ (PINTask<ObjectType> *)value:(ObjectType)value PIN_WARN_UNUSED_RESULT;
+ (PINTask<ObjectType> *)error:(NSError *)error PIN_WARN_UNUSED_RESULT;

- (PINTask<ObjectType> *)executor:(id<PINExecutor>)executor doSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure PIN_WARN_UNUSED_RESULT;
- (__nullable PINCancellationBlock)run;

@end

@interface PINTask<ObjectType> (Compose)
- (PINTask<NSNull *> *)mapToNull PIN_WARN_UNUSED_RESULT;
@end

NS_ASSUME_NONNULL_END

// Import everything for caller convenience.
#import "PINTask+All.h"
#import "PINTask+Cache.h"
#import "PINTask+Do.h"
#import "PINTask+DoAsync.h"
#import "PINTask2.h"
#import "PINTask2+Map.h"
#import "PINTask2+FlatMap.h"
#import "PINTask2+MapToValue.h"
