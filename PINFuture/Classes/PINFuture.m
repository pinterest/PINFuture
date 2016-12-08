//
//  PINFuture.m
//  Pinterest
//
//  Created by Chris Danford on 11/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

#import "PINExecution.h"

typedef void(^CompletionBlockType)(NSError *error, NSObject *value);

typedef NS_ENUM(NSUInteger, PINFutureState) {
    PINFutureStatePending = 0,
    PINFutureStateResolved,
    PINFutureStateRejected,
};

@interface PINFutureCallback : NSObject
@property (nonatomic) PINExecutionContext context;
@property (nonatomic) void(^completion)(NSError *error, NSObject *value);
@end

@implementation PINFutureCallback
@end

@interface PINFuture ()

@property (nonatomic) NSLock *propertyLock;
@property (nonatomic) enum PINFutureState state;
@property (nonatomic) id value;
@property (nonatomic) NSError *error;
@property (nonatomic) NSMutableArray<PINFutureCallback *> *callbacks;

@end

@implementation PINFuture

- (instancetype)init
{
    self = [super init];
    if (self) {
        _propertyLock = [NSLock new];
    }
    return self;
}

+ (PINFuture<id> *)futureWithValue:(id)value
{
    PINFuture<id> *future = [[PINFuture alloc] init];
    future.state = PINFutureStateResolved;
    future.value = value;
    return future;
}

+ (PINFuture<id> *)futureWithError:(NSError *)error
{
    PINFuture<id> *future = [[PINFuture alloc] init];
    future.state = PINFutureStateRejected;
    future.error = error;
    return future;
}

+ (PINFuture<id> *)futureWithBlock:(void(^)(void(^resolve)(id), void(^reject)(NSError *)))block
{
    PINFuture<id> *future = [[PINFuture alloc] init];
    block(^(id value) {
        [future transitionToState:PINFutureStateResolved value:value error:nil];
    }, ^(NSError *error) {
        [future transitionToState:PINFutureStateRejected value:nil error:error];
    });
    return future;
}

#pragma mark - attach callbacks

- (void)context:(PINExecutionContext)context completion:(void(^)(NSError *error, id))completion
{
    PINFutureCallback *callback = [[PINFutureCallback alloc] init];
    callback.context = context;
    callback.completion = completion;
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

- (void)transitionToState:(PINFutureState)state value:(NSObject *)value error:(NSError *)error
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
        callback.context(^{
            callback.completion(self.error, self.value);
        })();
    }
}

@end

@implementation PINFuture (Convenience)

+ (PINFuture<NSNull *> *)futureWithNull
{
    return [PINFuture futureWithValue:[NSNull null]];
}

- (void)context:(PINExecutionContext)context success:(void(^)(id value))success failure:(void(^)(NSError *error))failure;
{
    return [self context:context completion:^(NSError *error, NSObject * value) {
        if (error != nil) {
            if (failure != NULL) {
                failure(error);
            }
        } else {
            if (success != NULL) {
                success(value);
            }
        }
    }];
}

- (void)context:(PINExecutionContext)context success:(void(^)(id value))success
{
    [self context:context success:success failure:^(NSError * _Nonnull error) {}];
}

- (void)completion:(void(^)(NSError *error, id value))completion
{
    return [self context:[PINExecution defaultContextForCurrentThread] completion:completion];
}

- (void)success:(void(^)(id value))success failure:(void(^)(NSError *error))failure;
{
    return [self context:[PINExecution defaultContextForCurrentThread] success:success failure:failure];
}

- (void)success:(void(^)(id value))success
{
    return [self context:[PINExecution defaultContextForCurrentThread] success:success];
}

- (PINFuture<NSNull *> *)mapToNull:(PINFuture<id>)sourceFuture
{
    return [PINMap<id, NSNull *> map:sourceFuture
                                    success:^NSNull * _Nonnull(NSObject * _Nonnull fromValue) {
                                        return [NSNull null]];
                                    }];
}

@end
