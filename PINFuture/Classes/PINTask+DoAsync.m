//
//  PINTask+DoAsync.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+DoAsync.h"

@implementation PINTask (DoAsync)

- (PINTask<id> *)executor:(id<PINExecutor>)executor doAsyncSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    // Tricky: We immediately execute these callbacks, but the callbacks themselves dispatch to the supplied context;
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

- (PINTask<id> *)executor:(id<PINExecutor>)executor doAsyncCompletion:(void(^)(void))completion
{
    return [self executor:executor doAsyncSuccess:^(id  _Nonnull value) {
        completion();
    } failure:^(NSError * _Nonnull error) {
        completion();
    }];
}

@end
