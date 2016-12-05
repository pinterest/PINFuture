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

describe(@"these will fail", ^{

    it(@"futureWithValue", ^{
        NSNumber *value = @1;
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithValue:value];
        expectFutureToResolveWith(self, future, value);
    });

    it(@"testFutureWithError", ^{
        NSError *error = [[NSError alloc] init];
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithError:error];
        expectFutureToRejectWith(self, future, error);
    });
    
    it(@"testFutureWithBlockResolve", ^{
        NSNumber *value = @1;
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithBlock:^(void (^ _Nonnull resolve)(NSNumber * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            resolve(value);
            resolve(value);
            reject([[NSError alloc] init]);
        }];
        expectFutureToResolveWith(self, future, value);
    });
    
    it(@"testFutureWithBlockReject", ^{
        NSError *error = [[NSError alloc] init];
        // Calls to resolve or reject after the first should be ignored.
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> futureWithBlock:^(void (^ _Nonnull resolve)(NSNumber * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            reject(error);
            reject(error);
            resolve(@1);
        }];
        expectFutureToRejectWith(self, future, error);
    });
    
    it(@"testDispatchResolve", ^{
        NSNumber *value = @4;
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> dispatchWithQueue:dispatch_get_main_queue() block:^PINFuture<NSNumber *> * _Nonnull{
            return [PINFuture futureWithValue:value];
        }];
        expectFutureToResolveWith(self, future, value);
    });
    
    it(@"testDispatchReject", ^{
        NSError *error = [[NSError alloc] init];
        PINFuture<NSNumber *> *future = [PINFuture<NSNumber *> dispatchWithQueue:dispatch_get_main_queue() block:^PINFuture<NSNumber *> * _Nonnull{
            return [PINFuture futureWithError:error];
        }];
        expectFutureToRejectWith(self, future, error);
    });
    
    
    it(@"will wait for 10 seconds and fail", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd
