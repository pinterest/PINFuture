//
//  PINFuture+Dispatch.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (Dispatch)

+ (PINFuture<ObjectType> *)dispatchWithQueue:(dispatch_queue_t)queue block:(PINFuture<ObjectType> * (^)())block;

@end

NS_ASSUME_NONNULL_END
