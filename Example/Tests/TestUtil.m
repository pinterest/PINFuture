//
//  TestUtil.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "TestUtil.h"

void expectFutureToFulfillWith(id testCase, PINFuture *future, id expectedValue) {
    waitUntil(^(DoneCallback done) {
        [future executor:PINExecutor.immediate success:^(id  _Nonnull value) {
            id self = testCase;
            expect(value).to.equal(expectedValue);
            done();
        } failure:^(NSError * _Nonnull error) {
            NSCAssert(NO, @"expected to resolve, not reject");
            done();
        }];
    });
}

void expectFutureToRejectWith(id testCase, PINFuture *future, NSError *expectedError) {
    waitUntil(^(DoneCallback done) {
        [future executor:PINExecutor.immediate success:^(id  _Nonnull value) {
            NSCAssert(NO, @"expected to reject, not resolve");
            done();
        } failure:^(NSError * _Nonnull error) {
            id self = testCase;
            expect(error).to.equal(expectedError);
            done();
        }];
    });
}

void runTaskAndExpectToFulfillWith(id testCase, PINTask *task, id expectedValue) {
    waitUntil(^(DoneCallback done) {
        [[[task executor:PINExecutor.immediate doSuccess:^(id  _Nonnull value) {
            id self = testCase;
            expect(value).to.equal(expectedValue);
        } failure:^(NSError * _Nonnull error) {
            NSCAssert(NO, @"Task should have succeeded but didn't.");
        }] executor:PINExecutor.immediate doCompletion:^{
            done();
        }] run];
    });
}

void runTaskAndExpectToRejectWith(id testCase, PINTask *task, NSError *expectedError) {
    waitUntil(^(DoneCallback done) {
        [[[task executor:PINExecutor.immediate doSuccess:^(id  _Nonnull value) {
            NSCAssert(NO, @"Task should have failed but didn't.");
        } failure:^(NSError * _Nonnull error) {
            id self = testCase;
            expect(error).to.equal(expectedError);
        }] executor:PINExecutor.immediate doCompletion:^{
            done();
        }] run];
    });
}


static NSInteger counter = 0;

NSNumber *numberFixture() {
    return @(counter++);
}

NSString *stringFixture() {
    return [NSString stringWithFormat:@"fixture%ld", (long)counter++];
}

NSError *errorFixture() {
    return [NSError errorWithDomain:NSCocoaErrorDomain code:counter++ userInfo:nil];
}
