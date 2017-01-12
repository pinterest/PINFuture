//
//  PINDispatchProxy.m
//  Pods
//
//  Created by Chris Danford on 12/9/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINDispatchProxy.h"
#import "PINFuture.h"

@interface PINDispatchProxy ()

@property (nonatomic, strong) id<PINExecutor> executor;
@property (nonatomic, strong) id target;

@end

@implementation PINDispatchProxy

+ (instancetype)proxyWithExecutor:(id<PINExecutor>)executor target:(id)target
{
    PINDispatchProxy *proxy = [PINDispatchProxy alloc];
    proxy.executor = executor;
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSAssert(strcmp(invocation.methodSignature.methodReturnType, @encode(PINFuture *)) == 0, @"only able to proxy methods that return a `PINFuture *`");

    // TODO(chris): This should copy but is crashing when the copy is invoked.  Why?
    //NSInvocation *invocationCopy = [invocation copy];

    PINFuture *immediateFuture = [PINFuture dispatchWithExecutor:self.executor block:^PINFuture * _Nonnull{
        // calling invoke will have the side-effect of setting the returnValue
        [invocation invokeWithTarget:self.target];
        void *returnValue = nil;
        [invocation getReturnValue:&returnValue];
        PINFuture *returnedFuture = (__bridge PINFuture *)returnValue;
        return returnedFuture;
    }];
    [invocation setReturnValue:&immediateFuture];
}

@end
