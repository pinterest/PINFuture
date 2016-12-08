//
//  PINFuture2+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture2.h"

#import "PINFuture.h"

@implementation PINFuture2 (FlatMap)

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture
                               context:(PINExecutionContext)context
                             success:(PINFuture<id> *(^)(id fromValue))success
                             failure:(PINFuture<id> *(^)(NSError * error))failure
{
    return [PINFuture futureWithBlock:^(void (^resolve)(NSObject *), void (^reject)(NSError *)) {
        [sourceFuture context:context success:^(NSObject *value) {
            PINFuture<id> *newFuture = success(value);
            NSAssert(newFuture != nil, @"returned future must not be nil");
            [newFuture context:context success:^(NSObject *value) {
                resolve(value);
            } failure:^(NSError *error) {
                reject(error);
            }];
        } failure:^(NSError *error) {
            PINFuture<id> *newFuture = failure(error);
            NSAssert(newFuture != nil, @"returned future must not be nil");
            [newFuture context:context success:^(NSObject *value) {
                resolve(value);
            } failure:^(NSError *error) {
                reject(error);
            }];
        }];
    }];
}

@end

@implementation PINFuture2 (FlatMapConvenience)

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture
                               context:(PINExecutionContext)context
                             success:(PINFuture<id> *(^)(id fromValue))success
{
    return [self flatMap:sourceFuture context:context success:success failure:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture futureWithError:error];
    }];
}

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture
                             success:(PINFuture<id> *(^)(id fromValue))success
                             failure:(PINFuture<id> *(^)(NSError * error))failure;
{
    return [self flatMap:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success failure:failure];
}

+ (PINFuture<id> *)flatMap:(PINFuture<NSObject *> *)sourceFuture
                             success:(PINFuture<id> *(^)(id fromValue))success;
{
    return [self flatMap:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success];
}

@end
