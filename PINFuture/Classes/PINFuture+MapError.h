//
//  PINFuture+MapError.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//

#import "PINFuture.h"

@interface PINFuture<ObjectType> (MapError)

- (PINFuture<ObjectType> *)context:(PINExecutionContext)context mapError:(ObjectType (^)(NSError *error))mapError;
- (PINFuture<ObjectType> *)mapError:(ObjectType (^)(NSError *error))mapError;

@end
