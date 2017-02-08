//
//  PINFutureUtil.h
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (GatherAll)

/**
 * From an array of Futures, create one new future that resolves with an array of the future values.
 * If any of the original futures reject, then the returned future rejects with the error of the first rejection.
 */
+ (PINFuture<NSArray<ObjectType> *> *)gatherAll:(NSArray<PINFuture<ObjectType> *> *)sourceFutures PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
