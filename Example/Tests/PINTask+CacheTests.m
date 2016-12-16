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
        PINTask<NSString *> *sourceTask = [PINTask<NSString *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            callCount++;
            resolve(initialValue);
            return NULL;
        }];
        PINTask<NSString *> *cachedTask = [sourceTask cache];
        
        PINTask<NSArray<NSString *> *> *taskThatCallsTwice = [PINTask<NSString *> all:@[cachedTask, cachedTask]];
        
        // Intentionally call `runTask` twice.
        waitUntil(^(DoneCallback done) {
            [[taskThatCallsTwice doCompletion:^(NSError * _Nonnull error, NSArray<NSString *> *_Nonnull value) {
                expect(value).to.equal(@[initialValue, initialValue]);
                expect(error).to.beNil();

                // The original task should have been executed only once.
                expect(callCount).to.equal(1);
                
                done();
            }] run];
        });
    });
});

SpecEnd
