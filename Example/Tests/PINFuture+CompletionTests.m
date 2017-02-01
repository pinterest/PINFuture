//
//  PINFuture+CompletionTests.m
//  PINFuture
//
//  Created by Chris Danford on 1/28/17.
//  Copyright © 2017 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureCompletionSpecs)

describe(@"completion", ^{
    
    // This executor always dispatches to the main queue to ensure that the future won't resolve until the callstack has unwound.
    id<PINExecutor> delayedExecutor = [PINExecutor queue:dispatch_get_main_queue()];
    
    it(@"expected callbacks called for a fulfilled Future", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> withValue:value];
        __block BOOL completionCalled = NO;
        [future executor:delayedExecutor completion:^{
            completionCalled = YES;
        }];
        expectFutureToFulfillWith(self, future, value);
        expect(completionCalled).to.beTruthy();
    });
    
    it(@"expected callbacks called for a rejected Future", ^{
        NSError *error = errorFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> withError:error];
        __block BOOL completionCalled = NO;
        [future executor:delayedExecutor completion:^{
            completionCalled = YES;
        }];
        expectFutureToRejectWith(self, future, error);
        expect(completionCalled).to.beTruthy();
    });
});

SpecEnd
