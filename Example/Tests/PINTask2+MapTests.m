//
//  PINTask2+MapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTask2MapSpecs)

describe(@"map", ^{
    it(@"can return a value of a different type", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> value:valueA];
        PINTask<NSString *> *taskB = [PINTask2<NSNumber *, NSString *> map:taskA success:^NSString *(NSNumber *fromValue) {
            return valueB;
        }];
        runTaskAndExpectToResolveWith(self, taskB, valueB);
    });
});

SpecEnd
