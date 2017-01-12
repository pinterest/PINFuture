//
//  PINTask+DoAsync.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> (DoAsync)

- (PINTask<ObjectType> *)executor:(id<PINExecutor>)executor doAsyncSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure PIN_WARN_UNUSED_RESULT;
- (PINTask<ObjectType> *)executor:(id<PINExecutor>)executor doAsyncCompletion:(void(^)(void))completion PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
