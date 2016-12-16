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

- (PINTask<ObjectType> *)doCompletion:(void(^)(NSError *error, ObjectType value))completion;
- (PINTask<ObjectType> *)doAsyncSuccess:(nullable void(^)(ObjectType value))success failure:(nullable void(^)(NSError *error))failure;
- (PINTask<ObjectType> *)doAsyncCompletion:(void(^)(NSError *error, ObjectType value))completion;

@end

NS_ASSUME_NONNULL_END
