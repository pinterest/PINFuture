#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif

#import "ALAssetsLibrary+PINFuture.h"
#import "ALAssetsLibrary+PINTask.h"
#import "NSURLSession+PINFuture.h"
#import "NSURLSession+PINTask.h"
#import "PHImageManager+PINFuture.h"
#import "PHImageManager+PINTask.h"
#import "PINCancelToken.h"
#import "PINDefines.h"
#import "PINDispatchProxy.h"
#import "PINExecutor.h"
#import "PINFuture+All.h"
#import "PINFuture+Dispatch.h"
#import "PINFuture+FlatMapError.h"
#import "PINFuture+MapError.h"
#import "PINFuture.h"
#import "PINFutureMap+FlatMap.h"
#import "PINFutureMap+Map.h"
#import "PINFutureMap.h"
#import "PINOnce.h"
#import "PINPair.h"
#import "PINResult.h"
#import "PINResult2.h"
#import "PINResultFailure.h"
#import "PINResultSuccess.h"
#import "PINTask+All.h"
#import "PINTask+Cache.h"
#import "PINTask+Do.h"
#import "PINTask+DoAsync.h"
#import "PINTask.h"
#import "PINTaskMap+FlatMap.h"
#import "PINTaskMap+Map.h"
#import "PINTaskMap+MapToValue.h"
#import "PINTaskMap.h"

FOUNDATION_EXPORT double PINFutureVersionNumber;
FOUNDATION_EXPORT const unsigned char PINFutureVersionString[];

