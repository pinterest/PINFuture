//
//  PINTaskTests.m
//  PINTaskTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskSpecs)

describe(@"task", ^{
    it(@"create with value", ^{
        NSString *value = stringFixture();
        PINTask<NSString *> *task = [PINTask<NSString *> value:value];
        runTaskAndExpectToResolveWith(self, task, value);
    });
    
    it(@"create with error", ^{
        NSError *error = errorFixture();
        PINTask<NSString *> *task = [PINTask<NSString *> error:error];
        runTaskAndExpectToRejectWith(self, task, error);
    });
    
    it(@"resolves only once", ^{
        NSString *value = stringFixture();
        // Calls to resolve or reject after the first should be ignored.
        PINTask<NSString *> *task = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            resolve(value);
            resolve(value);
            reject(errorFixture());
            return NULL;
        }];
        runTaskAndExpectToResolveWith(self, task, value);
    });
    
    it(@"rejects only once", ^{
        NSError *error = errorFixture();
        // Calls to resolve or reject after the first should be ignored.
        PINTask<NSString *> *task = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            reject(error);
            reject(error);
            resolve(stringFixture());
            return NULL;
        }];
        runTaskAndExpectToRejectWith(self, task, error);
    });
    
//    it(@"tolerates success callback being null", ^{
//        NSError *error = errorFixture();
//        PINTask<NSString *> *task = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
//            [[PINTask<NSString *> error:error] runAsyncSuccess:NULL failure:^(NSError * _Nonnull error) {
//                reject(error);
//            }];
//            return NULL;
//        }];
//        runTaskAndExpectToRejectWith(self, task, error);
//    });
//    
//    it(@"tolerates failure callback being null", ^{
//        NSString *value = stringFixture();
//        PINTask<NSString *> *task = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
//            resolve(value);
//            return NULL;
//        }];
//        runTaskAndExpectToRejectWith(self, task, value);
//    });

    it(@"can cache", ^{
        NSString *initialValue = stringFixture();
        __block NSUInteger callCount = 0;
        PINTask<NSString *> *sourceTask = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            callCount++;
            resolve(initialValue);
            return NULL;
        }];
        PINTask<NSString *> *cachedTask = [sourceTask cache];

        // Intentionally call `runTask` twice.
        for (NSUInteger i = 0; i < 2; i++) {
            waitUntil(^(DoneCallback done) {
                [cachedTask runAsyncCompletion:^(NSError * _Nonnull error, id _Nonnull value) {
                    expect(value).to.equal(initialValue);
                    expect(error).to.beNil();
                    // The original task should have been executed only once.
                    expect(callCount).to.equal(1);
                    done();
                }];
            });
        }
    });
});

SpecEnd
