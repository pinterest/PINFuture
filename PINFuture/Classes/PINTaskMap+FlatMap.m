//
//  PINTaskMap+FlatMap.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTaskMap+FlatMap.h"

#import "PINTask.h"

@implementation PINTaskMap (FlatMap)

+ (PINTask<id> *)executor:(id<PINExecutor>)executor flatMap:(PINTask<id> *)sourceTask success:(PINTask<id> *(^)(id fromValue))success
{
    return [PINTask<id> create:^PINCancelToken * (void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        PINTask<id> *taskWithSideEffects = [sourceTask executor:[PINExecutor immediate] doSuccess:^(id  _Nonnull value) {
            PINTask<id> *mappedTask = success(value);
            mappedTask = [mappedTask executor:executor doSuccess:resolve failure:reject];
            [mappedTask run];
        } failure:^(NSError * _Nonnull error) {
            reject(error);
        }];
        return [taskWithSideEffects run];
    }];
}

@end
