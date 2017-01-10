//
//  PINFuture+MapError.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINResult.h"

@interface PINFuture<ObjectType> (MapError)

- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor mapError:(PINResult<ObjectType> *(^)(NSError *error))mapError;

@end
