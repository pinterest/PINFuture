//
//  PINFuture+Dispatch.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Trampoline execution to another queue and return a Future.
 */
@interface PINFuture<ObjectType> (Dispatch)

+ (PINFuture<ObjectType> *)dispatchWithContext:(PINExecutionContext)context block:(PINFuture<ObjectType> * (^)())block;

@end

NS_ASSUME_NONNULL_END
