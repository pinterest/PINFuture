//
//  PINFuture+ChainSideEffect.h
//  Pods
//
//  Created by Chris Danford on 1/22/17.
//
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (ChainSideEffect)

/**
 * Like `executor:success:failure:`, but instead of returning `void` returns a PINFuture with the same value that won't resolve until the supplied callbacks have finished executing.
 */
- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor chainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void (^)(NSError * _Nonnull))failure PIN_WARN_UNUSED_RESULT;

/**
 * Like `executor:complete:`, but instead of returning `void` returns a PINFuture with the same value that won't resolve until the supplied callback has finished executing.
 */
- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor chainComplete:(void(^)(void))complete PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
