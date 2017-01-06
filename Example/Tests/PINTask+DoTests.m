//
//  PINTask+DoTests.m
//  PINTask+DoTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskDoSpecs)

describe(@"task do", ^{
    it(@"doCompletion executes side effect before continuing", ^{
        NSString *value = stringFixture();
        PINTask<NSString *> *task = [PINTask<NSString *> succeedWith:value];
        __block BOOL sideEffectExecuted = NO;
        task = [task executor:[PINExecutor immediate] doCompletion:^{
            sideEffectExecuted = YES;
        }];
        
        runTaskAndExpectToResolveWith(self, task, value);
        expect(sideEffectExecuted).to.beTruthy();
    });
});

SpecEnd
