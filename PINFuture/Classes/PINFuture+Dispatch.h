//
//  PINFuture+Dispatch.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Trampoline execution to another queue and return a Future.
 */
@interface PINFuture<ObjectType> (Dispatch)

+ (PINFuture<ObjectType> *)dispatchWithExecutor:(id<PINExecutor>)executor block:(PINFuture<ObjectType> * (^)(void))block PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
