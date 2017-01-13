//
//  PINFutureMap+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureMap+FlatMap.h"

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFutureMap (Map)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
              executor:(id<PINExecutor>)executor
             transform:(id (^)(id fromValue))transform
{
    return [self flatMap:sourceFuture executor:executor transform:^PINFuture<id> * _Nonnull(id  _Nonnull fromValue) {
        return [PINFuture<id> withValue:transform(fromValue)];
    }];
}

@end

@implementation PINFutureMap (MapConvenience)

+ (PINFuture<id> *)mapToValue:(PINFuture<id> *)sourceFuture
                        value:(id)value
{
    return [self map:sourceFuture executor:[PINExecutor immediate] transform:^id _Nonnull(id  _Nonnull fromValue) {
        return value;
    }];
}

@end

NS_ASSUME_NONNULL_END
