//
//  PINFuture.m
//  Pinterest
//
//  Created by Chris Danford on 11/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

#import "PINExecutor.h"
#import "PINFutureMap+Map.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PINFutureState) {
    PINFutureStatePending = 0,
    PINFutureStateFulfilled,
    PINFutureStateRejected,
};

@interface PINFutureCallback : NSObject
@property (nonatomic) id<PINExecutor> executor;
@property (nonatomic, copy, nullable) void(^success)(id value);
@property (nonatomic, copy, nullable) void(^failure)(NSError *error);
@end

@implementation PINFutureCallback
@end

@interface PINFuture ()

@property (nonatomic) NSLock *propertyLock;
// TODO(chris): Use PINResult here.
@property (nonatomic) enum PINFutureState state;
@property (nonatomic, nullable) id value;
@property (nonatomic, nullable) NSError *error;
@property (nonatomic, nullable) NSMutableArray<PINFutureCallback *> *callbacks;  // If nil, there are no callbacks

@end

@implementation PINFuture

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _propertyLock = [NSLock new];
    }
    return self;
}

- (void)setValue:(nullable id)value
{
    NSAssert([value isKindOfClass:[PINFuture class]] == NO, @"You should not fulfill a PINFuture with another PINFuture.  This is almost definintely a bug.");
    _value = value;
}

+ (PINFuture<id> *)withValue:(id)value
{
    NSParameterAssert(value != nil);
    NSParameterAssert([value isKindOfClass:[NSError class]] == NO);

    PINFuture<id> *future = [[PINFuture alloc] initPrivate];
    future.state = PINFutureStateFulfilled;
    future.value = value;
    return future;
}

+ (PINFuture<id> *)withError:(NSError *)error
{
    NSParameterAssert(error != nil);
    NSParameterAssert([error isKindOfClass:[NSError class]]);
    
    PINFuture<id> *future = [[PINFuture alloc] initPrivate];
    future.state = PINFutureStateRejected;
    future.error = error;
    return future;
}

+ (PINFuture<id> *)withBlock:(void(^)(void(^resolve)(id), void(^reject)(NSError *)))block
{
    PINFuture<id> *future = [[PINFuture alloc] initPrivate];
    block(^(id value) {
        NSParameterAssert(value != nil);
        NSParameterAssert([value isKindOfClass:[NSError class]] == NO);
        [future transitionToState:PINFutureStateFulfilled value:value error:nil];
    }, ^(NSError *error) {
        NSParameterAssert(error != nil);
        NSParameterAssert([error isKindOfClass:[NSError class]]);
        [future transitionToState:PINFutureStateRejected value:nil error:error];
    });
    return future;
}

#pragma mark - attach callbacks

- (void)executor:(id<PINExecutor>)executor success:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    PINFutureCallback *callback = [[PINFutureCallback alloc] init];
    callback.executor = executor;
    callback.success = success;
    callback.failure = failure;
    [self.propertyLock lock];
    // Lazily instantiate self.callbacks.  Lots of futures will never have any callbacks.
    if (self.callbacks == nil) {
        self.callbacks = [NSMutableArray new];
    }

    [self.callbacks addObject:callback];
    [self.propertyLock unlock];

    [self tryFlushCallbacks];
}

#pragma mark - internal

- (void)transitionToState:(PINFutureState)state value:(nullable NSObject *)value error:(nullable NSError *)error
{
    [self.propertyLock lock];
    if (self.state == PINFutureStatePending) {
        self.value = value;
        self.error = error;
        self.state = state;
    } else {
        //NSAssert(NO, @"a future executor callback was called more than once");
    }
    [self.propertyLock unlock];

    [self tryFlushCallbacks];
}

- (void)tryFlushCallbacks
{
    NSArray<PINFutureCallback *> *callbacks;

    [self.propertyLock lock];
    if (self.state != PINFutureStatePending) {
        // dequeue
        callbacks = self.callbacks;
        self.callbacks = nil;
    }
    [self.propertyLock unlock];

    // execute
    for (PINFutureCallback *callback in callbacks) {
        [callback.executor execute:^{
            // It's OK to access `self.state` here without locking because, if we hit this point,
            // `self.state` has reached a terminal value and cannot change further.
            switch (self.state) {
                case PINFutureStateFulfilled:
                    if (callback.success != NULL) {
                        callback.success(self.value);
                    }
                    break;
                case PINFutureStateRejected:
                    if (callback.failure != NULL) {
                        callback.failure(self.error);
                    }
                    break;
                default:
                    NSAssert(NO, @"unexpected state value");
            }
        }];
    }
}

@end

NS_ASSUME_NONNULL_END
