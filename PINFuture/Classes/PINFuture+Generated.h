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

- (void)executeOnMainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (void)executeOnBackgroundSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

- (void)executeOnMainCompletion:(nullable void(^)(void))completion;
- (void)executeOnBackgroundCompletion:(nullable void(^)(void))completion;

+ (PINFuture<ObjectType> *)executeOnMainBlock:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ObjectType> *)executeOnBackgroundBlock:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;

- (PINFuture<ObjectType> *)executeOnMainChainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void (^)(NSError * _Nonnull))failure PIN_WARN_UNUSED_RESULT;
- (PINFuture<ObjectType> *)executeOnBackgroundChainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void (^)(NSError * _Nonnull))failure PIN_WARN_UNUSED_RESULT;

- (PINFuture<ObjectType> *)executeOnMainChainCompletion:(void(^)(void))completion PIN_WARN_UNUSED_RESULT;
- (PINFuture<ObjectType> *)executeOnBackgroundChainCompletion:(void(^)(void))completion PIN_WARN_UNUSED_RESULT;

@end

@interface PINFutureMap<FromType, ToType> (Generated)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture executeOnMainTransform:(ToType (^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture executeOnBackgroundTransform:(ToType (^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture executeOnMainTransform:(PINFuture<ToType> *(^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;
+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture executeOnBackgroundTransform:(PINFuture<ToType> *(^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
