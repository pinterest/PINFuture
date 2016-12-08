//
//  PINThen.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINThen.h"

#import "PINFutureInternal.h"

@implementation PINThen

+ (PINFuture<id> *)then:(PINFuture<id> *)sourceFuture
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

@implementation PINThen (Convenience)

+ (PINFuture<id> *)then:(PINFuture<id> *)sourceFuture
                               context:(PINExecutionContext)context
                             success:(PINFuture<id> *(^)(id fromValue))success
{
    return [self then:sourceFuture context:context success:success failure:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture futureWithError:error];
    }];
}

+ (PINFuture<id> *)then:(PINFuture<id> *)sourceFuture
                             success:(PINFuture<id> *(^)(id fromValue))success
                             failure:(PINFuture<id> *(^)(NSError * error))failure;
{
    return [self then:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success failure:failure];
}

+ (PINFuture<id> *)then:(PINFuture<NSObject *> *)sourceFuture
                             success:(PINFuture<id> *(^)(id fromValue))success;
{
    return [self then:sourceFuture context:[PINExecution defaultContextForCurrentThread] success:success];
}

@end
