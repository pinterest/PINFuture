//
//  PINFuture+MapError.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <PINFuture/PINFutureDefinition.h>
#import <PINFuture/PINDefines.h>

@interface PINFuture<ObjectType> (MapError)

- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor mapError:(ObjectType (^)(NSError *error))mapError PIN_WARN_UNUSED_RESULT;

@end
