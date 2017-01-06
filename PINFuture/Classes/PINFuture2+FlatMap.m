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
                   executor:(id<PINExecutor>)executor
                   success:(PINFuture<id> *(^)(id fromValue))success
{
    return [PINFuture withBlock:^(void (^resolve)(NSObject *), void (^reject)(NSError *)) {
        [sourceFuture executor:executor success:^(NSObject *value) {
            PINFuture<id> *newFuture = success(value);
            NSAssert(newFuture != nil, @"returned future must not be nil");
            [newFuture executor:executor success:^(NSObject *value) {
                resolve(value);
            } failure:^(NSError *error) {
                reject(error);
            }];
        } failure:^(NSError *error) {
            reject(error);
        }];
    }];
}

@end

@implementation PINFuture2 (FlatMapConvenience)

+ (PINFuture<id> *)flatMap:(PINFuture<NSObject *> *)sourceFuture
                             success:(PINFuture<id> *(^)(id fromValue))success;
{
    return [self flatMap:sourceFuture executor:[PINExecutor defaultContextForCurrentThread] success:success];
}

@end
