//
//  PINFuture2+FlatMap.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "PINFuture2.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture2<FromType, ToType> (FlatMap)
+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                    context:(PINExecutionContext)context
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;

@end

@interface PINFuture2<FromType, ToType> (FlatMapConvenience)

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                      context:(PINExecutionContext)context
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;
+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

@end

NS_ASSUME_NONNULL_END
