//
//  PINTask+CacheTests.m
//  PINTask+CacheTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskCacheSpecs)

describe(@"cache", ^{
    it(@"only calls a cached task once", ^{
        NSString *initialValue = stringFixture();
        __block NSUInteger callCount = 0;
        PINTask<NSString *> *sourceTask = [PINTask<NSString *> new:^PINCancelToken * _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            callCount++;
            resolve(initialValue);
            return NULL;
        }];
        PINTask<NSString *> *cachedTask = [sourceTask cache];
        
        PINTask<NSArray<NSString *> *> *taskThatCallsTwice = [PINTask<NSString *> all:@[cachedTask, cachedTask]];
        
        // Intentionally call `runTask` twice.
        waitUntil(^(DoneCallback done) {
            [[[taskThatCallsTwice executor:[PINExecutor immediate] doSuccess:^(NSArray<NSString *> *_Nonnull value) {
                expect(value).to.equal(@[initialValue, initialValue]);

                // The original task should have been executed only once.
                expect(callCount).to.equal(1);
            } failure:^(NSError * _Nonnull error) {
                NSCAssert(NO, @"expected success but failed");
            }] executor:[PINExecutor immediate] doCompletion:^{
                done();
            }] run];
        });
    });
});

SpecEnd
