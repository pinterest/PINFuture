//
//  PINFuture+ChainSideEffect.m
//  Pods
//
//  Created by Chris Danford on 1/22/17.
//
//

#import "PINFuture+ChainSideEffect.h"

#import "PINFutureMap+Map.h"

@implementation PINFuture (ChainSideEffect)

- (PINFuture<id> *)executor:(id<PINExecutor>)executor chainSideEffectSuccess:(nullable void(^)(id value))success 
{
    return [PINFutureMap<id, id> map:self executor:executor transform:^id _Nonnull(id  _Nonnull value) {
        if (success != nil) {
            success(value);
        }
        return value;
    }];
}

@end
