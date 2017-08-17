//
//  PINFutureMap+FlatMap.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureMap.h"

#import "PINFuture.h"
#import "PINFutureError.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFutureMap (FlatMap)

+ (PINFuture<id> *)flatMap:(PINFuture<id> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                   transform:(PINFuture<id> *(^)(id fromValue))transform
{
    return [PINFuture withBlock:^(void (^resolve)(id), void (^reject)(NSError *)) {
        [sourceFuture executor:executor success:^(id value) {
            PINFuture<id> *newFuture = transform(value);
            NSString *reason = @"A flatMap block returned nil, but it must return a PINFuture.";
            NSAssert(newFuture != nil, reason);
            if (newFuture == nil) {
                NSError *error = [PINFutureError errorWithReason:reason];
                reject(error);
            } else {
                [newFuture executor:executor success:^(id value) {
                    resolve(value);
                } failure:^(NSError *error) {
                    reject(error);
                }];
            }
        } failure:^(NSError *error) {
            reject(error);
        }];
    }];
}

@end

NS_ASSUME_NONNULL_END
