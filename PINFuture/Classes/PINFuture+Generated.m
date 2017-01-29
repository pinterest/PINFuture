//
//  PINFuture+Generated.m
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//

#import "PINFuture+Generated.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFuture (Generated)

- (void)onMainSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure;
{
    return [self executor:[PINExecutor main] success:success failure:failure];
}

- (void)onBackgroundSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    return [self executor:[PINExecutor background] success:success failure:failure];
}

@end

NS_ASSUME_NONNULL_END
