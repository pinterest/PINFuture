//
//  PINFuture+MapError.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//
//

#import "PINFuture+MapError.h"

@implementation PINFuture (MapError)

- (PINFuture<id> *)context:(PINExecutionContext)context mapError:(id (^)(NSError *error))mapError
{
    return [self context:[PINExecution defaultContextForCurrentThread] flatMapError:^PINFuture * _Nonnull(NSError * _Nonnull error) {
        return [PINFuture<id> futureWithError:mapError(error)];
    }];
}

- (PINFuture<id> *)mapError:(id (^)(NSError *error))mapError
{
    return [self context:[PINExecution defaultContextForCurrentThread] mapError:mapError];
}

@end
