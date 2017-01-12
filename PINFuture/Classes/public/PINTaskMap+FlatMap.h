//
//  PINTaskMap+FlatMap.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "PINTaskMap.h"

@interface PINTaskMap<FromType, ToType> (FlatMap)
+ (PINTask<ToType> *)executor:(id<PINExecutor>)executor flatMap:(PINTask<FromType> *)sourceTask success:(PINTask<ToType> *(^)(FromType fromValue))success PIN_WARN_UNUSED_RESULT;
@end
