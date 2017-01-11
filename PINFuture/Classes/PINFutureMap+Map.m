//
//  PINFutureMap+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureMap+FlatMap.h"

#import "PINFuture.h"

@implementation PINFutureMap (Map)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               executor:(id<PINExecutor>)executor
               transform:(PINResult<id> *(^)(id fromValue))transform
{
    return [self flatMap:sourceFuture
                executor:executor
                 transform:^PINFuture * _Nonnull(id  _Nonnull fromValue) {
                     return [PINResult2<id, id> match:transform(fromValue) success:^id _Nonnull(id  _Nonnull value) {
                         return [PINFuture withValue:value];
                     } failure:^id _Nonnull(NSError * _Nonnull error) {
                         return [PINFuture withError:error];
                     }];
                 }];
}

@end

@implementation PINFutureMap (MapConvenience)

+ (PINFuture<id> *)mapValue:(PINFuture<id> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                  transform:(id (^)(id fromValue))transform
{
    return [self map:sourceFuture executor:executor transform:^PINResult * _Nonnull(id  _Nonnull fromValue) {
        return [PINResult withValue:transform(fromValue)];
    }];
}

@end
