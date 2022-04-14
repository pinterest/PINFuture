//
//  PINFuture+GatherSome.h
//  Pods
//
//  Created by Chris Danford on 8/16/17.
//
//

#import <Foundation/Foundation.h>
#import <PINFuture/PINFuture.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (GatherSome)

/**
 * EXPERIMENTAL.  This API may change to improve type safety.
 *
 * From an array of Futures, create one new future that resolves with an array of future values and/or nulls.
 * For an original future that resolve, the corresponding location in the final array is filled a value.
 * For an original future that rejects, the corresponding location in the final array is filled with `[NSNull null]`.
 */
+ (PINFuture<NSArray *> *)gatherSome:(NSArray<PINFuture<ObjectType> *> *)sourceFutures PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
