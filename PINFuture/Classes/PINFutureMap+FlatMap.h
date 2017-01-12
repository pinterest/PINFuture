//
//  PINFutureMap+FlatMap.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINFutureMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureMap<FromType, ToType> (FlatMap)

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                      executor:(id<PINExecutor>)executor
                     transform:(PINFuture<ToType> *(^)(FromType fromValue))transform;

@end

NS_ASSUME_NONNULL_END
