//
//  PINFuture+Delay.h
//  Pinterest
//
//  Created by Chris Danford on 4/16/18.
//

#import <PINFuture/PINFuture+MapToValue.h>

NS_ASSUME_NONNULL_BEGIN

typedef PINFuture<NSNull *> PINFutureNoValue;

@interface PINFuture (Delay)

/** Return a future that resolves after the specified amount of time. */
+ (PINFutureNoValue *)delay:(NSTimeInterval)seconds;

@end

NS_ASSUME_NONNULL_END
