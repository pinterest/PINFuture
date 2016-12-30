//
//  PINCancelTokenTests.m
//  PINFuture
//
//  Created by Brandon Kase on 12/30/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINCancelTokenSpecs)

describe(@"cancel tokens", ^{
    it(@"cancellation works", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> value:valueA];
        PINTask<NSString *> *taskB = [PINTask2<NSNumber *, NSString *> context:[PINExecution immediate] map:taskA success:^PINResult<NSString *> *(NSNumber *fromValue) {
            return [PINResult succeedWith:valueB];
        }];
        runTaskAndExpectToResolveWith(self, taskB, valueB);
    });
});

SpecEnd