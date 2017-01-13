//
//  PINTask+Do.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask+Do.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINTask (Do)

- (PINTask<id> *)executor:(id<PINExecutor>)executor doCompletion:(void(^)(void))completion
{
    return [self executor:executor doSuccess:^(id _Nonnull value) {
        completion();
    } failure:^(NSError * _Nonnull error) {
        completion();
    }];
}

@end

NS_ASSUME_NONNULL_END
