//
//  PINFuture+Dispatch.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <PINFuture/PINFutureDefinition.h>
#import <PINFuture/PINDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (Dispatch)

/**
 * Create a future by executing a block.
 */
+ (PINFuture<ObjectType> *)executor:(id<PINExecutor>)executor block:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
