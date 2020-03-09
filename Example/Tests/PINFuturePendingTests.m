//
//  PINFuturePendingTests.m
//  PINFuture_Example
//
//  Created by Ray Cho on 3/8/20.
//  Copyright © 2020 Pinterest. All rights reserved.
//


#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFuturePendingSpecs)

describe(@"future pending", ^{
    it(@"can return the underlying future waiting to be resolved or rejected", ^{
        PINFuturePending *futurePending = [[PINFuturePending alloc] init];
        expect(futurePending.future).toNot.beNil();
        expect(futurePending.future).to.beKindOf(PINFuture.class);
    });

    it(@"resolves when called to fulfill the future", ^{
        NSString *value = stringFixture();
        PINFuturePending<NSString *> *futurePending = [[PINFuturePending alloc] init];
        [futurePending fulfillWithValue:value];
        expectFutureToFulfillWith(self, futurePending.future, value);
    });
         
    it(@"rejects when called to reject the future", ^{
        NSError *error = errorFixture();
        PINFuturePending<NSString *> *futurePending = [[PINFuturePending alloc] init];
        [futurePending rejectWithError:error];
        expectFutureToRejectWith(self, futurePending.future, error);
    });

    it(@"allows chaining with order", ^{
        NSString *fulfilledValue = stringFixture();
        PINFuturePending<NSString *> *futurePending = [[PINFuturePending alloc] init];
        __block NSUInteger chainCount = 0;
        [futurePending.future executor:[PINExecutor immediate] success:^(NSString * _Nonnull value) {
            chainCount += 1;
            expect(chainCount).to.equal(1);
            expect(value).to.equal(fulfilledValue);
        } failure:^(NSError * _Nonnull error) {
            NSCAssert(NO, @"expected to resolve, not reject");
        }];
        [futurePending.future executor:[PINExecutor immediate] success:^(NSString * _Nonnull value) {
            chainCount += 1;
            expect(chainCount).to.equal(2);
            expect(value).to.equal(fulfilledValue);
        } failure:^(NSError * _Nonnull error) {
            NSCAssert(NO, @"expected to resolve, not reject");
        }];
        [futurePending fulfillWithValue:fulfilledValue];
    });

    it(@"allows to fulfill only once", ^{
        expect(^{
            NSString *value = stringFixture();
            PINFuturePending<NSString *> *futurePending = [[PINFuturePending alloc] init];
            [futurePending fulfillWithValue:value];
            [futurePending fulfillWithValue:value];
        }).to.raiseAny();
    });

    it(@"allows to reject only once", ^{
        expect(^{
            NSError *error = errorFixture();
            PINFuturePending<NSString *> *futurePending = [[PINFuturePending alloc] init];
            [futurePending rejectWithError:error];
            [futurePending rejectWithError:error];
        }).to.raiseAny();
    });
});

SpecEnd
