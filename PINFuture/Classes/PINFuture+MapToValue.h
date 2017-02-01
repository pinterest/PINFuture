//
//  PINFuture+MapToValue.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

/**
 * A Future that has no meaningful value.  Technically, it does have a value (an NSNull)
 * but the value should not ever be used.
 */
typedef PINFuture<NSNull *> PINFutureNoValue;

@interface PINFuture<ObjectType> (MapToValue)

+ (PINFuture<ObjectType> *)map:(PINFuture *)future toValue:(ObjectType)value PIN_WARN_UNUSED_RESULT;

- (PINFutureNoValue *)mapToNoValue;

@end
