//
//  PINFuture+NoValue.h
//  PINFuture
//
//  Created by Chris Danford on 4/16/18.
//

#import <PINFuture/PINFutureDefinition.h>

/**
 * A Future that has no meaningful value.  Technically, it does have a value (an NSNull).
 */
typedef PINFuture<NSNull *> PINFutureNoValue;

@interface PINFuture (NoValue)

+ (PINFutureNoValue *)withNull;

- (PINFutureNoValue *)mapToNoValue;

@end
