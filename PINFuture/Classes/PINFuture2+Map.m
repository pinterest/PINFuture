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
               context:(PINExecutionContext)context
               success:(id (^)(id fromValue))success
               failure:(id (^)(NSError * error))failure
{
    return [self flatMap:sourceFuture
                 context:context
                 success:^PINFuture * _Nonnull(id  _Nonnull fromValue) {
                     return [PINFuture futureWithValue:success(fromValue)];
                 } failure:^PINFuture * _Nonnull(NSError * _Nonnull error) {
                     return [PINFuture futureWithError:failure(error)];
                 }];
}

@end

@implementation PINFuture2 (MapConvenience)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               context:(PINExecutionContext)context
               success:(id (^)(id fromValue))success
{
    return [self map:sourceFuture context:context success:success failure:^NSError * _Nonnull(NSError * _Nonnull error) {
        return error;
    }];
}

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               success:(id (^)(id fromValue))success
               failure:(id (^)(NSError * error))failure
{
    return [self map:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success failure:failure];
}

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               success:(id (^)(id fromValue))success
{
    return [self map:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success];
}

@end
