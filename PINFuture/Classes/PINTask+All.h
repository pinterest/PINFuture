//
//  PINTask+All.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> (All)
+ (PINTask<NSArray<ObjectType> *> *)all:(NSArray<PINTask<ObjectType> *> *)tasks PIN_WARN_UNUSED_RESULT;
@end

NS_ASSUME_NONNULL_END
