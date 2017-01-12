//
//  PINResultSuccess.h
//  Pods
//
//  Created by Brandon Kase on 12/19/16.
//
//

#import "PINResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A Result is value that has either succeeded or failed.
 */
@interface PINResultSuccess<ObjectType> : PINResult<ObjectType>

/**
 * Return a successful result.
 */
- (PINResultSuccess<ObjectType> *)initWithValue:(ObjectType)value;

@end

NS_ASSUME_NONNULL_END