//
//  PINFutureMap+Map.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINFutureMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureMap<FromType, ToType> (Map)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                   transform:(ToType (^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

@end

@interface PINFutureMap<FromType, ToType> (MapConvenience)

+ (PINFuture<ToType> *)mapToValue:(PINFuture<FromType> *)sourceFuture
                            value:(ToType)value PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
