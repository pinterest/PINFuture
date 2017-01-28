//
//  PINFuture+Complete.h
//  Pods
//
//  Created by Chris Danford on 1/28/17.
//  Copyright (c) 2017 Pinterest. All rights reserved.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINFuture<ObjectType> (Complete)

/**
 * Execute a block on success or on failure.  Use this if you want to have a side-effect and nothing 
 * needs to wait on your side-effect to complete.
 */
- (void)executor:(id<PINExecutor>)executor completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
