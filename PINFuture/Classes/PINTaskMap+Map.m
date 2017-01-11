//
//  PINTaskMap+Map.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTaskMap+Map.h"

#import "PINTaskMap+FlatMap.h"

@implementation PINTaskMap (Map)

+ (PINTask<id> *)executor:(id<PINExecutor>)executor map:(PINTask<id> *)sourceTask success:(PINResult<id> *(^)(id))success
{
    return [self executor:executor
                 flatMap:sourceTask
                 success:^PINTask * _Nonnull(id  _Nonnull fromValue) {
                     return [PINResult2<id, id> match:success(fromValue) success:^id _Nonnull(id  _Nonnull value) {
                         return [PINTask withValue:value];
                     } failure:^id _Nonnull(NSError * _Nonnull error) {
                         return [PINTask withError:error];
                     }];
                 }];
}

@end
