//
//  PINFuture+Generated.h
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

// TODO(chris): Generate files in this directory.

@interface PINFuture<ObjectType> (Generated)

- (void)onMainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (void)onBackgroundSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

- (void)onMainCompletion:(nullable void(^)(void))completion;
- (void)onBackgroundCompletion:(nullable void(^)(void))completion;

+ (PINFuture<ObjectType> *)dispatchOnMainBlock:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ObjectType> *)dispatchOnBackgroundBlock:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;

@end

@interface PINFutureMap<FromType, ToType> (Generated)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture onMainTransform:(ToType (^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture onBackgroundTransform:(ToType (^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture onMainTransform:(PINFuture<ToType> *(^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture onBackgroundTransform:(PINFuture<ToType> *(^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
