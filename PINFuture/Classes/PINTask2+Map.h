//
//  PINTask2+Map.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "PINTask2.h"

@interface PINTask2<FromType, ToType> (Map)
+ (PINTask<ToType> *)map:(PINTask<FromType> *)sourceTask success:(ToType (^)(FromType fromValue))success PIN_WARN_UNUSED_RESULT;
@end
