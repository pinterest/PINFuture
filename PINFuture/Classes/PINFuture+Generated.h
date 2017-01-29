//
//  PINFuture+Generated.h
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

// TODO(chris): Generate files in this directory.

@interface PINFuture<ObjectType> (Generated)

- (void)onMainSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (void)onBackgroundSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
