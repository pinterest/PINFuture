//
//  PINCancelTokenTests.m
//  PINFuture
//
//  Created by Brandon Kase on 12/30/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

// TODO: Do real cancel tests
/*SpecBegin(PINCancelTokenSpecs)

describe(@"cancel tokens", ^{
    it(@"cancellation works", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> value:valueA];
        PINTask<NSString *> *taskB = [PINTaskMap<NSNumber *, NSString *> executor:PINExecutor.immediate map:taskA success:^PINFuture<NSString *> *(NSNumber *fromValue) {
            return [PINFuture withValue:valueB];
        }];
        runTaskAndExpectToFulfillWith(self, taskB, valueB);
    });
});

SpecEnd*/
