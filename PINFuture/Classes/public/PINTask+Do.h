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

- (PINTask<ObjectType> *)executor:(id<PINExecutor>)executor doCompletion:(void(^)(void))completion PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
