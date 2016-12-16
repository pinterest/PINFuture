//
//  PINTask2+FlatMap.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask2+FlatMap.h"

#import "PINTask.h"

@implementation PINTask2 (FlatMap)

+ (PINTask<id> *)flatMap:(PINTask<id> *)sourceTask success:(PINTask<id> *(^)(id fromValue))success
{
    return [PINTask<id> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        PINTask<id> *taskWithSideEffects = [sourceTask doSuccess:^(id  _Nonnull value) {
            PINTask<id> *mappedTask = success(value);
            mappedTask = [mappedTask doSuccess:resolve failure:reject];
            [mappedTask run];
        } failure:^(NSError * _Nonnull error) {
            reject(error);
        }];
        return [taskWithSideEffects run];
    }];
}

@end
