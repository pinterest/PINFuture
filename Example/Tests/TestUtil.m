//
//  TestUtil.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "TestUtil.h"

void expectFutureToResolveWith(id testCase, PINFuture *future, id expectedValue) {
    waitUntil(^(DoneCallback done) {
        [future completion:^(NSError * _Nonnull error, id value) {
            id self = testCase;
            expect(value).to.equal(expectedValue);
            done();
        }];
    });
}

void expectFutureToRejectWith(id testCase, PINFuture *future, NSError *expectedError) {
    waitUntil(^(DoneCallback done) {
        [future completion:^(NSError * _Nonnull error, id value) {
            id self = testCase;
            expect(error).to.equal(expectedError);
            done();
        }];
    });
}

void runTaskAndExpectToResolveWith(id testCase, PINTask *task, id expectedValue) {
    waitUntil(^(DoneCallback done) {
        [[task doCompletion:^(NSError * _Nonnull error, id _Nonnull value) {
            id self = testCase;
            expect(value).to.equal(expectedValue);
            expect(error).to.beNil();
            done();
        }] run];
    });
}

void runTaskAndExpectToRejectWith(id testCase, PINTask *task, NSError *expectedError) {
    waitUntil(^(DoneCallback done) {
        [[task doCompletion:^(NSError * _Nonnull error, id _Nonnull value) {
            id self = testCase;
            expect(value).to.beNil();
            expect(error).to.equal(expectedError);
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
