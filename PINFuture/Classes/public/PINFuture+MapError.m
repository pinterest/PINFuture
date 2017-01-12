//
//  PINFuture+MapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+MapError.h"

#import "PINResult2.h"

@implementation PINFuture (MapError)

- (PINFuture<id> *)executor:(id<PINExecutor>)executor mapError:(id (^)(NSError *error))mapError
{
    return [self executor:executor flatMapError:^PINFuture<id> * _Nonnull(NSError * _Nonnull error) {
        return [PINResult2<id, PINFuture<id> *> match:mapError(error) success:^PINFuture<id> * _Nonnull(id  _Nonnull value) {
            return [PINFuture<id> withValue:value];
        } failure:^PINFuture<id> * _Nonnull(NSError * _Nonnull error) {
            return [PINFuture<id> withError:error];
        }];
    }];
}

@end
