//
//  PINFutureAndCancelToken.h
//  Pods
//
//  Created by Chris Danford on 1/16/17.
//

#import <Foundation/Foundation.h>

#import "PINCancelToken.h"
#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureAndCancelToken<ObjectType> : NSObject
+ (instancetype)newWithCancelToken:(PINCancelToken *)cancelToken future:(PINFuture<ObjectType> *)future PIN_WARN_UNUSED_RESULT;

- (PINCancelToken *)cancelToken;
- (PINFuture<ObjectType> *)future;
@end

NS_ASSUME_NONNULL_END
