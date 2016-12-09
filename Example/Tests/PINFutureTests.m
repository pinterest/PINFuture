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

SpecBegin(PINFutureSpecs)

describe(@"future", ^{
    it(@"create with value", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> futureWithValue:value];
        expectFutureToResolveWith(self, future, value);
    });

    it(@"create with error", ^{
        NSError *error = errorFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> futureWithError:error];
        expectFutureToRejectWith(self, future, error);
    });

    it(@"resolves only once", ^{
        NSString *value = stringFixture();
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSString *> *future = [PINFuture<NSString *> futureWithBlock:^(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            resolve(value);
            resolve(value);
            reject(errorFixture());
        }];
        expectFutureToResolveWith(self, future, value);
    });

    it(@"rejects only once", ^{
        NSError *error = errorFixture();
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSString *> *future = [PINFuture<NSString *> futureWithBlock:^(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            reject(error);
            reject(error);
            resolve(numberFixture());
        }];
        expectFutureToRejectWith(self, future, error);
    });
});

SpecEnd
