//
//  PINFuture+Generated.m
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//

#import "PINFuture+Generated.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFuture (Generated)

- (void)executeOnMainSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure;
{
    return [self executor:[PINExecutor main] success:success failure:failure];
}

- (void)executeOnBackgroundSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    return [self executor:[PINExecutor background] success:success failure:failure];
}

- (void)executeOnMainCompletion:(nullable void(^)(void))completion
{
    return [self executor:[PINExecutor main] completion:completion];
}

- (void)executeOnBackgroundCompletion:(nullable void(^)(void))completion
{
    return [self executor:[PINExecutor background] completion:completion];
}

+ (PINFuture<id> *)executeOnMainBlock:(PINFuture<id> * (^)(void))block
{
    return [self dispatchWithExecutor:[PINExecutor main] block:block];
}

+ (PINFuture<id> *)executeOnBackgroundBlock:(PINFuture<id> * (^)(void))block
{
    return [self dispatchWithExecutor:[PINExecutor background] block:block];
}

@end


@implementation PINFutureMap (Generated)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture executeOnMainTransform:(id (^)(id fromValue))transform
{
    return [PINFutureMap<id, id> map:sourceFuture executor:[PINExecutor main] transform:transform];
}

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture executeOnBackgroundTransform:(id (^)(id fromValue))transform
{
    return [PINFutureMap<id, id> map:sourceFuture executor:[PINExecutor background] transform:transform];
}

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture executeOnMainTransform:(PINFuture<id> *(^)(id fromValue))transform
{
    return [PINFutureMap<id, id> flatMap:sourceFuture executor:[PINExecutor main] transform:transform];
}

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture executeOnBackgroundTransform:(PINFuture<id> *(^)(id fromValue))transform
{
    return [PINFutureMap<id, id> flatMap:sourceFuture executor:[PINExecutor background] transform:transform];
}

@end

NS_ASSUME_NONNULL_END
