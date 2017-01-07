//
//  PINFuture2+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture2+FlatMap.h"

#import "PINFuture.h"

@implementation PINFuture2 (Map)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               executor:(id<PINExecutor>)executor
               success:(PINResult<id> *(^)(id fromValue))success
{
    return [self flatMap:sourceFuture
                executor:executor
                 success:^PINFuture * _Nonnull(id  _Nonnull fromValue) {
                     return [PINResult2<id, id> match:success(fromValue) success:^id _Nonnull(id  _Nonnull value) {
                         return [PINFuture succeedWith:value];
                     } failure:^id _Nonnull(NSError * _Nonnull error) {
                         return [PINFuture failWith:error];
                     }];
                 }];
}

@end

@implementation PINFuture2 (MapConvenience)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               success:(PINResult<id> *(^)(id fromValue))success
{
    return [self map:sourceFuture executor:[PINExecutor defaultContextForCurrentThread] success:success];
}

+ (PINFuture<id> *)mapValue:(PINFuture<id> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                    success:(id (^)(id fromValue))success
{
    return [self map:sourceFuture executor:executor success:^PINResult * _Nonnull(id  _Nonnull fromValue) {
        return [PINResult succeedWith:success(fromValue)];
    }];
}

@end
