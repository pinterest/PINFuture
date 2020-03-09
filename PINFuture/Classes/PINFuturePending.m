//
//  PINFuturePending.m
//  Pods
//
//  Created by Ray Cho on 2/20/20.
//

#import "PINFuturePending.h"

@interface PINFuturePending ()
@property (nonatomic, strong) PINFuture<id> *pendingFuture;
@property (nonatomic, copy) void (^resolve)(id value);
@property (nonatomic, copy) void (^reject)(NSError *error);
@end

@implementation PINFuturePending

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pendingFuture = [PINFuture withBlock:^(void (^_Nonnull resolve)(id), void (^_Nonnull reject)(NSError *_Nonnull)) {
            self.resolve = resolve;
            self.reject = reject;
        }];
    }
    return self;
}

- (PINFuture<id> *)future
{
    return self.pendingFuture;
}

- (void)fulfillWithValue:(id)value
{
    NSParameterAssert(value != nil);
    NSParameterAssert([value isKindOfClass:[NSError class]] == NO);

    if (self.resolve) {
        self.resolve(value);
    } else {
        NSAssert(NO, @"Underlying future has already been resolved.");
    }

    self.resolve = nil;
    self.reject = nil;
}

- (void)rejectWithError:(NSError *)error
{
    NSParameterAssert(error != nil);
    NSParameterAssert([error isKindOfClass:[NSError class]]);

    if (self.reject) {
        self.reject(error);
    } else {
        NSAssert(NO, @"Underlying future has already been resolved.");
    }

    self.resolve = nil;
    self.reject = nil;
}

@end
