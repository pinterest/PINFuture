//
//  PINTask+Do.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+Do.h"

@implementation PINTask (Do)

- (PINTask<id> *)executor:(id<PINExecutor>)executor doCompletion:(void(^)())completion
{
    return [self executor:executor doSuccess:^(id _Nonnull value) {
        completion([PINResult<id> succeedWith:value]);
    } failure:^(NSError * _Nonnull error) {
        completion([PINResult<id> failWith:error]);
    }];
}

@end
