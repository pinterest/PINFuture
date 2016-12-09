//
//  TestUtil.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

#import "TestUtil.h"

void expectFutureToResolveWith(id testCase, PINFuture *future, id expectedValue) {
    waitUntil(^(DoneCallback done) {
        [future completion:^(NSError * _Nonnull error, NSNumber * _Nonnull value) {
            id self = testCase;
            expect(value).to.equal(expectedValue);
            done();
        }];
    });
}

void expectFutureToRejectWith(id testCase, PINFuture *future, NSError *expectedError) {
    waitUntil(^(DoneCallback done) {
        [future completion:^(NSError * _Nonnull error, NSNumber * _Nonnull value) {
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
