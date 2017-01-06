//
//  PINTask+Do.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+Do.h"

@implementation PINTask (Do)

- (PINTask<id> *)executor:(id<PINExecutor>)executor doCompletion:(void(^)(NSError *error, id value))completion
{
    return [self executor:executor doSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

- (PINTask<id> *)executor:(id<PINExecutor>)executor doAsyncSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    // Tricky: We immediately execute these callbacks, but the callback themselves dispatch to the supplied context;
    return [self executor:[PINExecutor immediate] doSuccess:^(id _Nonnull value) {
        [executor execute:^{
            if (success != NULL) {
                success(value);
            }
        }];
    } failure:^(NSError * _Nonnull error) {
        [executor execute:^{
            if (failure != NULL) {
                failure(error);
            }
        }];
    }];
}

- (PINTask<id> *)executor:(id<PINExecutor>)executor doAsyncCompletion:(void(^)(NSError *error, id value))completion
{
    return [self executor:executor doAsyncSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

@end
