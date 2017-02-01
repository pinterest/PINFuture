//
//  PINFuture+Completion.m
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//  Copyright (c) 2017 Pinterest. All rights reserved.
//

#import "PINFuture+Completion.h"

@implementation PINFuture (Completion)

- (void)executor:(id<PINExecutor>)executor completion:(void(^)(void))completion
{
    return [self executor:executor success:^(id  _Nonnull value) {
        completion();
    } failure:^(NSError * _Nonnull error) {
        completion();
    }];
}

@end
