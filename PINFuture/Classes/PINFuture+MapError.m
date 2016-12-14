//
//  PINFuture+MapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+MapError.h"

@implementation PINFuture (MapError)

- (PINFuture<id> *)context:(PINExecutionContext)context mapError:(id (^)(NSError *error))mapError
{
    return [self context:[PINExecution defaultContextForCurrentThread] flatMapError:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture<id> withError:mapError(error)];
    }];
}

- (PINFuture<id> *)mapError:(NSError *(^)(NSError *error))mapError
{
    return [self context:[PINExecution defaultContextForCurrentThread] mapError:mapError];
}

@end
