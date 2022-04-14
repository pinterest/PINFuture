//
//  PINFuture+FlatMapError.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <PINFuture/PINFuture.h>

@interface PINFuture<ObjectType> (FlatMapError)

- (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor flatMapError:(PINFuture<ObjectType> *(^)(NSError *error))flatMapError PIN_WARN_UNUSED_RESULT;

@end
