//
//  PINFuture+NoValue.m
//  PINFuture
//
//  Created by Chris Danford on 4/16/18.
//

#import "PINFuture+NoValue.h"

#import "PINFuture+MapToValue.h"

@implementation PINFuture (NoValue)

+ (PINFutureNoValue *)withNull
{
    return [PINFuture withValue:[NSNull null]];
}

- (PINFutureNoValue *)mapToNoValue
{
    return [PINFuture<NSNull *> map:self toValue:[NSNull null]];
}

@end
