//
//  PINFutureMap+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureMap.h"

#import "PINFuture.h"

@implementation PINFutureMap (FlatMap)

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                   transform:(PINFuture<id> *(^)(id fromValue))transform
{
    return [PINFuture withBlock:^(void (^resolve)(NSObject *), void (^reject)(NSError *)) {
        [sourceFuture executor:executor success:^(NSObject *value) {
            PINFuture<id> *newFuture = transform(value);
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
