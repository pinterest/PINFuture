//
//  PINDispatchProxy.h
//  Pods
//
//  Created by Chris Danford on 12/9/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecution.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINDispatchProxy : NSProxy

+ (instancetype)proxyWithContext:(PINExecutionContext)context target:(id)target;

@end

NS_ASSUME_NONNULL_END
