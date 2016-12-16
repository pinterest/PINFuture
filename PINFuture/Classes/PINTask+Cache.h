//
//  PINTask+Cache.h
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> (Cache)
- (PINTask<ObjectType> *)cache;
@end

NS_ASSUME_NONNULL_END

