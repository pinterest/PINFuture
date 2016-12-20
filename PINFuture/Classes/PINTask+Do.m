//
//  PINTask+Do.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+Do.h"

@implementation PINTask (Do)

- (PINTask<id> *)context:(PINExecutionContext)context doCompletion:(void(^)(NSError *error, id value))completion
{
    return [self context:context doSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

- (PINTask<id> *)context:(PINExecutionContext)context doAsyncSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    // Tricky: We immediately execute these callbacks, but the callback themselves dispatch to the supplied context;
    return [self context:[PINExecution immediate] doSuccess:^(id _Nonnull value) {
        context(^{
            if (success != NULL) {
                success(value);
            }
        })();
    } failure:^(NSError * _Nonnull error) {
        context(^{
            if (failure != NULL) {
                failure(error);
            }
        })();
    }];
}

- (PINTask<id> *)context:(PINExecutionContext)context doAsyncCompletion:(void(^)(NSError *error, id value))completion
{
    return [self context:context doAsyncSuccess:^(id  _Nonnull value) {
        completion(nil, value);
    } failure:^(NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

@end
