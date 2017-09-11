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
        [future executor:[PINExecutor immediate] success:^(id  _Nonnull value) {
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
        [future executor:[PINExecutor immediate] success:^(id  _Nonnull value) {
            NSCAssert(NO, @"expected to reject, not resolve");
            done();
        } failure:^(NSError * _Nonnull error) {
            id self = testCase;
            expect(error).to.equal(expectedError);
            done();
        }];
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
