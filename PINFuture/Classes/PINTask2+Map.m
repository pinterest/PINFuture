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

+ (PINTask<id> *)context:(PINExecutionContext)context map:(PINTask<id> *)sourceTask success:(id (^)(id fromValue))success
{
    return [self context:context
                 flatMap:sourceTask
                 success:^PINTask * _Nonnull(id  _Nonnull fromValue) {
                     return [PINResult2<id, id> match:success(fromValue) success:^id _Nonnull(id  _Nonnull value) {
                         return [PINTask value:value];
                     } failure:^id _Nonnull(NSError * _Nonnull error) {
                         return [PINTask error:error];
                     }];
                 }];
}


@end
