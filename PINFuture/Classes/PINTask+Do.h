//
//  PINTask+Do.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> (Do)

- (PINTask<ObjectType> *)doCompletion:(void(^)(NSError *error, ObjectType value))completion __attribute__((warn_unused_result));
- (PINTask<ObjectType> *)doAsyncSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure __attribute__((warn_unused_result));
- (PINTask<ObjectType> *)doAsyncCompletion:(void(^)(NSError *error, ObjectType value))completion __attribute__((warn_unused_result));

@end

NS_ASSUME_NONNULL_END
