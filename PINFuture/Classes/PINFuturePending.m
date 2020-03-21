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
    NSAssert(self.resolve, @"Underlying future has already been resolved.");

    if (self.resolve) {
        self.resolve(value);
    }

    self.resolve = nil;
    self.reject = nil;
}

- (void)rejectWithError:(NSError *)error
{
    NSParameterAssert(error != nil);
    NSParameterAssert([error isKindOfClass:[NSError class]]);
    NSAssert(self.reject, @"Underlying future has already been resolved.");

    if (self.reject) {
        self.reject(error);
    }

    self.resolve = nil;
    self.reject = nil;
}

@end
