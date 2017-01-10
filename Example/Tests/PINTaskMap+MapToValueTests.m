//
//  PINTaskMap+MapToValueTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskMapMapToValueSpecs)

describe(@"mapToValue", ^{
    it(@"can return a value of a different type", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> succeedWith:valueA];
        PINTask<NSString *> *taskB = [PINTaskMap<NSNumber *, NSString *> executor:[PINExecutor immediate] mapToValue:taskA success:^NSString *(NSNumber *fromValue) {
            return valueB;
        }];
        runTaskAndExpectToResolveWith(self, taskB, valueB);
    });
});

SpecEnd
