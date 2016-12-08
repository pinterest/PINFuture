//
//  PINFuture2+Map.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINFuture2.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture2<FromType, ToType> (Map)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   context:(PINExecutionContext)context
                   success:(ToType (^)(FromType fromValue))success
                   failure:(NSError *(^)(NSError * error))failure;

@end

@interface PINFuture2<FromType, ToType> (MapConvenience)

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   context:(PINExecutionContext)context
                   success:(ToType (^)(FromType fromValue))success;

+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   success:(ToType (^)(FromType fromValue))success
                   failure:(NSError *(^)(NSError * error))failure;
+ (PINFuture<ToType> *)map:(PINFuture<FromType> *)sourceFuture
                   success:(ToType (^)(FromType fromValue))success;

@end

NS_ASSUME_NONNULL_END
