//
//  PINFutureMap+FlatMap.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PINFuture/PINFuture.h>
#import <PINFuture/PINFutureMap.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureMap<FromType, ToType> (FlatMap)

+ (PINFuture<ToType> *)flatMap:(PINFuture<FromType> *)sourceFuture
                      executor:(id<PINExecutor>)executor
                     transform:(PINFuture<ToType> *(^)(FromType fromValue))transform PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
