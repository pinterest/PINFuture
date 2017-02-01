//
//  PINFuture+ChainSideEffect.m
//  Pods
//
//  Created by Chris Danford on 1/22/17.
//  Copyright (c) 2017 Pinterest. All rights reserved.
//

#import "PINFuture+ChainSideEffect.h"

#import "PINFutureMap+Map.h"
#import "PINFuture+FlatMapError.h"

@implementation PINFuture (ChainSideEffect)

- (PINFuture<id> *)executor:(id<PINExecutor>)executor chainSuccess:(nullable void(^)(id value))success failure:(nullable void (^)(NSError * _Nonnull))failure
{
    PINFuture<id> *chained = self;
    if (success != nil) {
        chained = [PINFutureMap<id, id> map:chained executor:executor transform:^id _Nonnull(id  _Nonnull value) {
            success(value);
            return value;
        }];
    };
    if (failure != nil) {
        chained = [chained executor:executor flatMapError:^PINFuture<id> *(NSError *error) {
            failure(error);
            return [PINFuture<id> withError:error];
        }];
    }
    return chained;
}

- (PINFuture<id> *)executor:(id<PINExecutor>)executor chainCompletion:(void(^)(void))completion
{
    NSParameterAssert(completion);
    return [self executor:executor chainSuccess:^(id  _Nonnull value) {
        completion();
    } failure:^(NSError * _Nonnull error) {
        completion();
    }];
}

@end
