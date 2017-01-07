//
//  PINFuture+MapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+MapError.h"
/*
@implementation PINFuture (MapError)

- (PINFuture<id> *)executor:(id<PINExecutor>)executor mapError:(id (^)(NSError *error))mapError
{
    return [self executor:[PINExecutor defaultContextForCurrentThread] flatMapError:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture<id> failWith:mapError(error)];
    }];
}

- (PINFuture<id> *)mapError:(NSError *(^)(NSError *error))mapError
{
    return [self executor:[PINExecutor defaultContextForCurrentThread] mapError:mapError];
}

@end
*/
