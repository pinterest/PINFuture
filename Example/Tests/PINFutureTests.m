//
//  PINFutureTests.m
//  PINFutureTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(FutureSpecs)

describe(@"future", ^{

    it(@"create with value", ^{
        NSNumber *value = @1;
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithValue:value];
        expectFutureToResolveWith(self, future, value);
    });

    it(@"create with error", ^{
        NSError *error = [[NSError alloc] init];
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithError:error];
        expectFutureToRejectWith(self, future, error);
    });

    it(@"resolves only once", ^{
        NSNumber *value = @1;
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithBlock:^(void (^ _Nonnull resolve)(NSNumber * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            resolve(value);
            resolve(value);
            reject([[NSError alloc] init]);
        }];
        expectFutureToResolveWith(self, future, value);
    });

    it(@"rejects only once", ^{
        NSError *error = [[NSError alloc] init];
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithBlock:^(void (^ _Nonnull resolve)(NSNumber * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            reject(error);
            reject(error);
            resolve(@1);
        }];
        expectFutureToRejectWith(self, future, error);
    });
});

SpecEnd
