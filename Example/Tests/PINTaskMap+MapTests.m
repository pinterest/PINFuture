//
//  PINTaskMap+MapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskMapMapSpecs)

describe(@"map", ^{
    it(@"can return a value of a different type", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> withValue:valueA];
        PINTask<NSString *> *taskB = [PINTaskMap<NSNumber *, NSString *> executor:[PINExecutor immediate] map:taskA success:^NSString *(NSNumber *fromValue) {
            return valueB;
        }];
        runTaskAndExpectToFulfillWith(self, taskB, valueB);
    });
});

SpecEnd
