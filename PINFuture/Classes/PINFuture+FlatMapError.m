//
//  PINFuture+FlatMapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+FlatMapError.h"

@implementation PINFuture (FlatMapError)

- (PINFuture<id> *)context:(PINExecutionContext)context flatMapError:(PINFuture<id> *(^)(NSError *error))flatMapError
{
    return [PINFuture<id> withBlock:^(void (^resolve)(id), void (^reject)(NSError *)) {
        [self context:context success:^(id  _Nonnull value) {
            // A value is passed through
            resolve(value);
        } failure:^(NSError * _Nonnull error) {
            // An error is given a chance to recover.
            PINFuture<id> *recoveredFuture = flatMapError(error);
            [recoveredFuture context:context success:^(id  _Nonnull value) {
                resolve(value);
            } failure:^(NSError * _Nonnull error) {
                reject(error);
            }];
        }];
    }];
}

- (PINFuture<id> *)flatMapError:(PINFuture<id> *(^)(NSError *error))flatMapError
{
    return [self context:[PINExecution defaultContextForCurrentThread] flatMapError:flatMapError];
}

@end
