//
//  PINFutureAndCancelToken.m
//  Pods
//
//  Created by Chris Danford on 1/16/17.
//

#import "PINFutureAndCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * It's common that a function will return both a Future and a CancelToken to aborting that work.
 * This class composes a Future and a CancelToken so that it can easily be returned as a single
 * value from a function.
 */
@interface PINFutureAndCancelToken ()
@property (nonatomic) PINCancelToken *cancelToken;
@property (nonatomic) PINFuture<id> *future;
@end

@implementation PINFutureAndCancelToken

+ (instancetype)newWithCancelToken:(PINCancelToken *)cancelToken future:(PINFuture<id> *)future
{
    PINFutureAndCancelToken *ret = [[self alloc] init];
    ret.cancelToken = cancelToken;
    ret.future = future;
    return ret;
}

@end

NS_ASSUME_NONNULL_END
