//
//  PINResultFailure.h
//  Pods
//
//  Created by Brandon Kase on 12/19/16.
//
//

#import "PINResult.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A Result is value that has either succeeded or failed.
 */
@interface PINResultFailure<ObjectType> : PINResult<ObjectType>

/**
 * Return a failed result.
 */
- (PINResultFailure<ObjectType> *)initWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END