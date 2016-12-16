//
//  PINTask+Dispatch.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//
//

#import "PINTask+Dispatch.h"

@implementation PINTask (Dispatch)

- (PINTask<id> *)dispatch:(PINExecutionContext)context
{
    NSAssert(context != NULL, @"context must not be null");
    return [PINTask<id> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        // contextify, and execute
        context(^{
            PINTask<id> *taskWithSideEffects = [self doSuccess:^(id _Nonnull value) {
                resolve(value);
            } failure:^(NSError * _Nonnull error) {
                reject(error);
            }];
            [taskWithSideEffects run];
        })();
        return NULL;
    }];
}

- (PINTask<id> *)dispatchDefault
{
    return [self dispatch:[PINExecution defaultContextForCurrentThread]];
}

@end
