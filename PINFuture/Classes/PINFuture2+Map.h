//
//  PINFuture2+Map.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINFuture2.h"
#import "PINResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture2<FromType, ToType> (Map)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   executor:(id<PINExecutor>)executor
                   transform:(PINResult<ToType> *(^)(FromType fromValue))transform;

@end

@interface PINFuture2<FromType, ToType> (MapConvenience)

+ (PINFuture<ToType> *)mapValue:(PINFuture<FromType> *)sourceFuture
                       executor:(id<PINExecutor>)executor
                        transform:(ToType (^)(FromType fromValue))transform;

@end

NS_ASSUME_NONNULL_END
