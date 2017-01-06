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
        PINTask<NSString *> *task = [PINTask<NSString *> succeedWith:value];
        runTaskAndExpectToResolveWith(self, task, value);
    });
    
    it(@"create with error", ^{
        NSError *error = errorFixture();
        PINTask<NSString *> *task = [PINTask<NSString *> failWith:error];
        runTaskAndExpectToRejectWith(self, task, error);
    });
    
    it(@"resolves only once", ^{
        NSString *value = stringFixture();
        // Calls to resolve or reject after the first should be ignored.
        PINTask<NSString *> *task = [PINTask<NSString *> create:^PINCancelToken * _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
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
        PINTask<NSString *> *task = [PINTask<NSString *> create:^PINCancelToken * _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            reject(error);
            reject(error);
            resolve(stringFixture());
            return NULL;
        }];
        runTaskAndExpectToRejectWith(self, task, error);
    });
    
    it(@"not calling `run` before dealloc will assert", ^{
        expect(^{
            NSString *value = stringFixture();
            __unused PINTask<NSString *> *task = [PINTask<NSString *> succeedWith:value];
        }).to.raise(@"NSInternalInconsistencyException");
    });

//    it(@"tolerates success callback being null", ^{
//        NSError *error = errorFixture();
//        PINTask<NSString *> *task = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
//            [[PINTask<NSString *> failWith:error] runAsyncSuccess:NULL failure:^(NSError * _Nonnull error) {
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
});

SpecEnd
