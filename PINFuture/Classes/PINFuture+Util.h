//
//  PINFutureUtil.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (Util)

+ (PINFuture<NSArray<ObjectType> *> *)all:(NSArray<PINFuture<ObjectType> *> *)sourceFutures;

@end

NS_ASSUME_NONNULL_END
