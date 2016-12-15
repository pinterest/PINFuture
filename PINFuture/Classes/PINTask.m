//
//  PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/12/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"

#import "PINFuture.h"
#import "PINOnce.h"

typedef NS_ENUM(NSUInteger, PINFutureState) {
    PINFutureStateUnstarted = 0,
    PINFutureStateStarted,
    PINFutureStateResolved,
    PINFutureStateRejected,
};


@interface PINFutureCallback : NSObject
@property (nonatomic) void(^completion)(NSError *error, id value);
@end

typedef PINCancellationBlock(^PINExecuteBlock)(void(^resolve)(id), void(^reject)(NSError *));

PINExecuteBlock resolveOrRejectOnceExecutionBlock(PINExecuteBlock block)
{
    NSLog(@"PINCancellationBlock 1");
    return ^PINCancellationBlock(void(^resolve)(id), void(^reject)(NSError *)) {
        NSLog(@"PINCancellationBlock 2");
        PINOnce *once = [[PINOnce alloc] init];
        return block(^(id value) {
            NSLog(@"PINCancellationBlock 3a");
            [once performOnce:^{
                NSLog(@"PINCancellationBlock 3b");
                resolve(value);
            }];
        }, ^(NSError *error) {
            NSLog(@"PINCancellationBlock 4a");
            [once performOnce:^{
                NSLog(@"PINCancellationBlock 4b");
                reject(error);
            }];
        });
    };
}

@interface PINTask ()
@property (nonatomic) PINExecuteBlock block;
@end

@implementation PINTask

+ (PINTask<id> *)new:(__nullable PINCancellationBlock(^)(void(^resolve)(id), void(^reject)(NSError *)))block
{
    PINTask<id> *task = [[PINTask alloc] init];
    task.block = block;
    return task;
}

+ (PINTask<id> *)value:(id)value
{
    return [self new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        resolve(value);
        return NULL;
    }];
}

+ (PINTask<id> *)error:(NSError *)error
{
    return [self new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        reject(error);
        return NULL;
    }];
}

- (__nullable PINCancellationBlock)runAsyncSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure;
{
    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
    onceBlock(^void(id value) {
        success(value);
    }, ^void(NSError *error) {
        failure(error);
    });
    return NULL;
}

- (__nullable PINCancellationBlock)runAsyncCompletion:(void(^)(NSError *error, id value))completion;
{
    NSLog(@"runAsyncCompletion 1");
    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
    onceBlock(^void(id value) {
        NSLog(@"runAsyncCompletion 2");
        completion(nil, value);
    }, ^void(NSError *error) {
        NSLog(@"runAsyncCompletion 3");
        completion(error, nil);
    });
    return NULL;
}

- (PINTask<id> *)cache
{
    NSLock *propertyLock = [NSLock new];
    __block enum PINFutureState currentState = PINFutureStateUnstarted;
    __block id finalValue = nil;
    __block NSError *finalError = nil;
    __block NSMutableArray<PINFutureCallback *> *callbacks;
    
    dispatch_block_t tryFlushCallbacks = ^{
        NSArray<PINFutureCallback *> *callbacksToExecute;
        [propertyLock lock];
        if (currentState == PINFutureStateResolved || currentState == PINFutureStateRejected) {
            callbacksToExecute = [callbacks copy];
            callbacks = nil;
        }
        [propertyLock unlock];
        
        // execute
        for (PINFutureCallback *callback in callbacksToExecute) {
            callback.completion(finalValue, finalError);
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
    return [PINTask<id> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        PINFutureCallback *callback = [[PINFutureCallback alloc] init];
        callback.completion = ^void(NSError *error, id value) {
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
            strongSelf.block(^void(id value) {
                transitionToState(PINFutureStateResolved, value, nil);
            }, ^void(NSError *error) {
                transitionToState(PINFutureStateRejected, nil, error);
            });
        } else {
            tryFlushCallbacks();
        }
        return NULL;
    }];
}

@end
