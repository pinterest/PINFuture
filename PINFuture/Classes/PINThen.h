//
//  PINThen.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This exists as a separate class so that the class can have two type parameters.
 */
@interface PINThen<FromType, ToType> : NSObject

+ (PINFuture<ToType> *)then:(PINFuture<FromType> *)sourceFuture
                      queue:(dispatch_queue_t)queue
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;

@end

@interface PINThen<FromType, ToType> (Convenience)

+ (PINFuture<ToType> *)then:(PINFuture<FromType> *)sourceFuture
                      queue:(dispatch_queue_t)queue
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

+ (PINFuture<ToType> *)then:(PINFuture<FromType> *)sourceFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success
                    failure:(PINFuture<ToType> *(^)(NSError * error))failure;
+ (PINFuture<ToType> *)then:(PINFuture<FromType> *)sourceFuture
                    success:(PINFuture<ToType> *(^)(FromType fromValue))success;

@end

NS_ASSUME_NONNULL_END
