//
//  PINTask2+FlatMapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTask2FlatMapSpecs)

describe(@"flatMap", ^{
    it(@"can return to a resolved value", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINTask<NSNumber *> *taskA = [PINTask<NSNumber *> succeedWith:valueA];
        PINTask<NSString *> *taskB = [PINTask2<NSNumber *, NSString *> executor:[PINExecutor immediate] flatMap:taskA success:^PINTask<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINTask<NSString *> succeedWith:valueB];
        }];
        runTaskAndExpectToResolveWith(self, taskB, valueB);
    });
    
    it(@"can map to a rejected error", ^{
        NSString *valueA = stringFixture();
        NSError *errorB = errorFixture();
        PINTask<NSString *> *taskA = [PINTask<NSString *> succeedWith:valueA];
        PINTask<NSString *> *taskB = [PINTask2<NSString *, NSString *> executor:[PINExecutor immediate] flatMap:taskA success:^PINTask<NSString *> * _Nonnull(NSString * _Nonnull fromValue) {
            return [PINTask<NSString *> failWith:errorB];
        }];
        runTaskAndExpectToRejectWith(self, taskB, errorB);
    });
});

SpecEnd
