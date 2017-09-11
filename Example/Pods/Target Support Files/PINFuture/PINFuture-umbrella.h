#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ALAssetsLibrary+PINFuture.h"
#import "NSURLSession+PINFuture.h"
#import "PHImageManager+PINFuture.h"
#import "PINNSURLSessionDataTaskResult.h"
#import "PINPHImageManagerImageDataResult.h"
#import "PINCancelToken.h"
#import "PINDefines.h"
#import "PINDispatchProxy.h"
#import "PINExecutor.h"
#import "PINFuture+ChainSideEffect.h"
#import "PINFuture+Completion.h"
#import "PINFuture+Dispatch.h"
#import "PINFuture+FlatMapError.h"
#import "PINFuture+GatherAll.h"
#import "PINFuture+GatherSome.h"
#import "PINFuture+Generated.h"
#import "PINFuture+MapError.h"
#import "PINFuture+MapToValue.h"
#import "PINFuture.h"
#import "PINFutureAndCancelToken.h"
#import "PINFutureError.h"
#import "PINFutureMap+FlatMap.h"
#import "PINFutureMap+Map.h"
#import "PINFutureMap.h"
#import "PINFutureOnce.h"
#import "PINPair.h"
#import "PINTuple.h"

FOUNDATION_EXPORT double PINFutureVersionNumber;
FOUNDATION_EXPORT const unsigned char PINFutureVersionString[];

