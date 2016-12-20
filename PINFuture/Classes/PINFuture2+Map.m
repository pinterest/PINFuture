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
               success:(PINResult<id> *(^)(id fromValue))success
{
    return [self flatMap:sourceFuture
                 context:context
                 success:^PINFuture * _Nonnull(id  _Nonnull fromValue) {
                     return [PINResult2<id, id> match:success(fromValue) success:^id _Nonnull(id  _Nonnull value) {
                         return [PINFuture withValue:value];
                     } failure:^id _Nonnull(NSError * _Nonnull error) {
                         return [PINFuture withError:error];
                     }];
                 }];
}

@end

@implementation PINFuture2 (MapConvenience)

+ (PINFuture<id> *)map:(PINFuture<id> *)sourceFuture
               success:(PINResult<id> *(^)(id fromValue))success
{
    return [self map:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success];
}

@end
