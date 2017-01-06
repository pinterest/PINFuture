//
//  PINTask2+MapToValue.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask2+MapToValue.h"

#import "PINTask2+Map.h"

@implementation PINTask2 (MapToValue)

+ (PINTask<id> *)executor:(id<PINExecutor>)executor mapToValue:(PINTask<id> *)sourceTask success:(id (^)(id))success
{
    return [self executor:executor map:sourceTask success:^PINResult *(id fromValue) {
        return [PINResult<id> succeedWith:success(fromValue)];
    }];
}

@end
