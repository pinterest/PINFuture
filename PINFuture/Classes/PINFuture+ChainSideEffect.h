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

- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor chainSideEffectSuccess:(nullable void(^)(ObjectType value))success PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
