//
//  PINFuture+MapToValue.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+MapToValue.h"

#import "PINFutureMap+Map.h"

@implementation PINFuture (MapToValue)

+ (PINFuture<id> *)map:(PINFuture *)future toValue:(id)value
{
    return [PINFutureMap<id, id> map:future executor:[PINExecutor immediate] transform:^id _Nonnull(id  _Nonnull fromValue) {
        return value;
    }];
}

@end
