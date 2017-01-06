//
//  PINTask+Cache.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//
//

#import "PINTask+Cache.h"

typedef NS_ENUM(NSUInteger, PINFutureState) {
    PINFutureStateUnstarted = 0,
    PINFutureStateStarted,
    PINFutureStateResolved,
    PINFutureStateRejected,
};

typedef void(^PINCompletionBlock)(NSError *error, id value);

@implementation PINTask (Cache)

- (PINTask<id> *)cache
{
    NSLock *propertyLock = [NSLock new];
    __block enum PINFutureState currentState = PINFutureStateUnstarted;
    __block id finalValue = nil;
    __block NSError *finalError = nil;
    __block NSMutableArray<PINCompletionBlock> *callbacks;
    
    dispatch_block_t tryFlushCallbacks = ^{
        NSArray<PINCompletionBlock> *callbacksToExecute;
        [propertyLock lock];
        if (currentState == PINFutureStateResolved || currentState == PINFutureStateRejected) {
            callbacksToExecute = [callbacks copy];
            callbacks = nil;
        }
        [propertyLock unlock];
        
        // execute
        for (PINCompletionBlock callback in callbacksToExecute) {
            callback(finalValue, finalError);
        }
    };
    
    void (^transitionToState)(PINFutureState newState, NSObject *value, NSError *error) = ^void(PINFutureState newState, NSObject *value, NSError *error) {
        [propertyLock lock];
        if (currentState == PINFutureStateStarted) {
            currentState = newState;
            finalValue = value;
            finalError = error;
        } else {
            //NSAssert(NO, @"a future executor callback was called more than once");
        }
        [propertyLock unlock];
        
        tryFlushCallbacks();
    };
    
    __weak typeof(self) weakSelf = self;
    return [PINTask<id> create:^PINCancelToken * (void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        PINCompletionBlock callback = ^void(NSError *error, id value) {
            switch (currentState) {
                case PINFutureStateResolved:
                    resolve(finalValue);
                    break;
                case PINFutureStateRejected:
                    reject(finalError);
                    break;
                default:
                    NSAssert(0, @"invalid `state");
                    break;
            }
        };
        [propertyLock lock];
        if (callbacks == nil) {
            callbacks = [[NSMutableArray alloc] init];
        }
        [callbacks addObject:callback];
        [propertyLock unlock];
        
        BOOL shouldBegin = NO;
        [propertyLock lock];
        if (currentState == PINFutureStateUnstarted) {
            currentState = PINFutureStateStarted;
            shouldBegin = YES;
        }
        [propertyLock unlock];
        if (shouldBegin) {
            PINTask<id> *taskWithSideEffects = [strongSelf executor:[PINExecutor immediate] doSuccess:^(id  _Nonnull value) {
                transitionToState(PINFutureStateResolved, value, nil);
            } failure:^(NSError * _Nonnull error) {
                transitionToState(PINFutureStateRejected, nil, error);
            }];
            [taskWithSideEffects run];
        } else {
            tryFlushCallbacks();
        }
        return NULL;
    }];
}

@end
