//
//  PINTask+Do.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+Do.h"

@implementation PINTask (Do)

- (PINTask<id> *)doCompletion:(void(^)(NSError *error, id value))completion
{
    return [self doSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

- (PINTask<id> *)doAsyncSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    PINExecutionContext context = [PINExecution defaultContextForCurrentThread];
    return [self doSuccess:^(id  _Nonnull value) {
        context(^{
            success(value);
        });
    } failure:^(NSError * _Nonnull error) {
        context(^{
            failure(error);
        });
    }];
}

- (PINTask<id> *)doAsyncCompletion:(void(^)(NSError *error, id value))completion
{
    return [self doAsyncSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

@end
