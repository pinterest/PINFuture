//
//  PINFuture+FlatMapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+FlatMapError.h"

#import "PINFutureError.h"

@implementation PINFuture (FlatMapError)

- (PINFuture<id> *)executor:(id<PINExecutor>)executor flatMapError:(PINFuture<id> *(^)(NSError *error))flatMapError
{
    return [PINFuture<id> withBlock:^(void (^resolve)(id), void (^reject)(NSError *)) {
        [self executor:executor success:^(id  _Nonnull value) {
            // A value is passed through
            resolve(value);
        } failure:^(NSError * _Nonnull error) {
            // An error is given a chance to recover.
            PINFuture<id> *recoveredFuture = flatMapError(error);
            NSString *reason = @"A flatMapError block returned nil, but it must return a PINFuture.";
            NSAssert(recoveredFuture != nil, reason);
            if (recoveredFuture == nil) {
                NSError *error = [PINFutureError errorWithReason:reason];
                reject(error);
            } else {
                [recoveredFuture executor:executor success:^(id  _Nonnull value) {
                    resolve(value);
                } failure:^(NSError * _Nonnull error) {
                    reject(error);
                }];
            }
        }];
    }];
}

@end
