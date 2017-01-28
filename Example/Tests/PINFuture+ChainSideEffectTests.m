//
//  PINFuture+ChainSideEffectTests.m
//  PINFuture
//
//  Created by Chris Danford on 1/27/17.
//  Copyright © 2017 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureChainSideEffectSpecs)

describe(@"chainSideEffect", ^{
    
    // This executor always dispatches to the main queue to ensure that the future won't resolve until the callstack has unwound.
    id<PINExecutor> delayedExecutor = [PINExecutor queue:dispatch_get_main_queue()];
    
    it(@"expected callbacks called for a fulfilled Future", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *chained = [PINFuture<NSString *> withValue:value];
        __block BOOL successCalled = NO;
        __block BOOL failureCalled = NO;
        __block BOOL completeCalled = NO;
        chained = [chained executor:delayedExecutor chainSuccess:^(NSString *value) {
            successCalled = YES;
        } failure:^(NSError *error) {
            failureCalled = YES;
        }];
        chained = [chained executor:delayedExecutor chainComplete:^{
            completeCalled = YES;
        }];
        expectFutureToFulfillWith(self, chained, value);
        expect(successCalled).to.beTruthy();
        expect(failureCalled).to.beFalsy();
        expect(completeCalled).to.beTruthy();
    });
    
    it(@"expected callbacks called for a rejected Future", ^{
        NSError *error = errorFixture();
        PINFuture<NSString *> *chained = [PINFuture<NSString *> withError:error];
        __block BOOL successCalled = NO;
        __block BOOL failureCalled = NO;
        __block BOOL completeCalled = NO;
        chained = [chained executor:delayedExecutor chainSuccess:^(NSString *value) {
            successCalled = YES;
        } failure:^(NSError *error) {
            failureCalled = YES;
        }];
        chained = [chained executor:delayedExecutor chainComplete:^{
            completeCalled = YES;
        }];
        expectFutureToRejectWith(self, chained, error);
        expect(successCalled).to.beFalsy();
        expect(failureCalled).to.beTruthy();
        expect(completeCalled).to.beTruthy();
    });

    it(@"chainSuccess:failure: doesn't blow up if callbacks are nil", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *chained = [PINFuture<NSString *> withValue:value];
        chained = [chained executor:delayedExecutor chainSuccess:nil failure:nil];
        expectFutureToFulfillWith(self, chained, value);
    });
});

SpecEnd
