//
//  PINTask+DoAsyncTests.m
//  PINTask+DoAsyncTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskDoAsyncSpecs)

describe(@"task doAsync", ^{
    it(@"doCompletion executes side effect before continuing", ^{
        NSString *value = stringFixture();
        PINTask<NSString *> *task = [PINTask<NSString *> value:value];
        __block BOOL sideEffectExecuted = NO;
        
        // This doAsync will be dispatched to the main queue, and the Task should execute before the stack unwinds
        // and therefore before the main queue is serviced.
        task = [task executor:[PINExecutor mainQueue] doAsyncCompletion:^{
            sideEffectExecuted = YES;
        }];
        
        waitUntil(^(DoneCallback done) {
            [[[task executor:[PINExecutor immediate] doSuccess:^(id  _Nonnull resolvedValue) {
                expect(resolvedValue).to.equal(value);
            } failure:^(NSError * _Nonnull error) {
                NSCAssert(NO, @"Task should have succeeded but didn't.");
            }] executor:[PINExecutor immediate] doCompletion:^{
                expect(sideEffectExecuted).to.beFalsy();
                done();
            }] run];
        });
    });
});

SpecEnd
