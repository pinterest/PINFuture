//
//  PINFutureUtil.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureUtil.h"

#import "PINFutureInternal.h"

@implementation PINFutureUtil

+ (PINFuture<id> *)transform:(PINFuture<id> *)fromFuture
                               queue:(dispatch_queue_t)queue
                             success:(PINFuture<id> *(^)(id fromValue))success
                             failure:(PINFuture<id> *(^)(NSError * error))failure
{
    return [PINFuture futureWithBlock:^(void (^resolve)(NSObject *), void (^reject)(NSError *)) {
        [fromFuture queue:queue success:^(NSObject *value) {
            PINFuture<id> *transformedFuture = success(value);
            NSAssert(transformedFuture != nil, @"returned future must not be nil");
            [transformedFuture queue:queue success:^(NSObject *value) {
                resolve(value);
            } failure:^(NSError *error) {
                reject(error);
            }];
        } failure:^(NSError *error) {
            PINFuture<id> *transformedFuture = failure(error);
            NSAssert(transformedFuture != nil, @"returned future must not be nil");
            [transformedFuture queue:queue success:^(NSObject *value) {
                resolve(value);
            } failure:^(NSError *error) {
                reject(error);
            }];
        }];
    }];
}

@end

@implementation PINFutureUtil (Convenience)

+ (PINFuture<id> *)transform:(PINFuture<id> *)fromFuture
                               queue:(dispatch_queue_t)queue
                             success:(PINFuture<id> *(^)(id fromValue))success
{
    return [self transform:fromFuture queue:queue success:success failure:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture futureWithError:error];
    }];
}

+ (PINFuture<id> *)transform:(PINFuture<id> *)fromFuture
                             success:(PINFuture<id> *(^)(id fromValue))success
                             failure:(PINFuture<id> *(^)(NSError * error))failure;
{
    return [self transform:fromFuture queue:defaultDispatchQueueForCurrentThread() success:success failure:failure];
}

+ (PINFuture<id> *)transform:(PINFuture<NSObject *> *)fromFuture
                             success:(PINFuture<id> *(^)(id fromValue))success;
{
    return [self transform:fromFuture queue:defaultDispatchQueueForCurrentThread() success:success];
}

@end
