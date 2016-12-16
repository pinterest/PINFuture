//
//  PINTask2+Map.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask2+Map.h"

#import "PINTask2+FlatMap.h"

@implementation PINTask2 (Map)

+ (PINTask<id> *)map:(PINTask<id> *)sourceTask success:(id (^)(id fromValue))success
{
    return [self flatMap:sourceTask
                 success:^PINTask * _Nonnull(id  _Nonnull fromValue) {
                     return [PINTask<id> value:success(fromValue)];
                 }];
}


@end
