//
//  PINTaskMap+MapToValue.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTaskMap+MapToValue.h"

#import "PINTaskMap+Map.h"

@implementation PINTaskMap (MapToValue)

+ (PINTask<id> *)executor:(id<PINExecutor>)executor mapToValue:(PINTask<id> *)sourceTask success:(id (^)(id))success
{
    return [self executor:executor map:sourceTask success:^id (id fromValue) {
        return success(fromValue);
    }];
}

@end
