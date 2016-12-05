//
//  PINFutureUtil.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureUtil<FromType, ToType> : NSObject

+ (PINFuture<ToType> *)transform:(PINFuture<FromType> *)fromFuture
                      queue:(dispatch_queue_t)queue
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;

@end

@interface PINFutureUtil<FromType, ToType> (Convenience)

+ (PINFuture<ToType> *)transform:(PINFuture<FromType> *)fromFuture
                      queue:(dispatch_queue_t)queue
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

+ (PINFuture<ToType> *)transform:(PINFuture<FromType> *)fromFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;
+ (PINFuture<ToType> *)transform:(PINFuture<FromType> *)fromFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

@end

NS_ASSUME_NONNULL_END
