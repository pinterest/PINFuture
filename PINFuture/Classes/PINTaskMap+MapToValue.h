//
//  PINTaskMap+MapToValue.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINResult.h"
#import "PINTask.h"
#import "PINTaskMap.h"

@interface PINTaskMap<FromType, ToType> (MapToValue)
+ (PINTask<ToType> *)executor:(id<PINExecutor>)executor mapToValue:(PINTask<FromType> *)sourceTask success:(ToType (^)(FromType fromValue))success PIN_WARN_UNUSED_RESULT;
@end
