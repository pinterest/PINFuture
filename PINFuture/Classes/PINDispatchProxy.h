//
//  PINDispatchProxy.h
//  Pods
//
//  Created by Chris Danford on 12/9/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecutor.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINDispatchProxy : NSProxy

+ (instancetype)proxyWithExecutor:(id<PINExecutor>)executor target:(id)target;

@end

NS_ASSUME_NONNULL_END
