//
//  PINTask+AllTests.m
//  PINTask+AllTests
//
//  Created by Chris Danford on 12/02/2016.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINTask.h"
#import "TestUtil.h"

SpecBegin(PINTaskAllSpecs)

describe(@"task all", ^{    
    it(@"resolves with expected values", ^{
        NSString *valueA = stringFixture();
        NSString *valueB = stringFixture();
        PINTask<NSString *> *sourceTaskA = [PINTask<NSString *> withValue:valueA];
        PINTask<NSString *> *sourceTaskB = [PINTask<NSString *> withValue:valueB];
        
        PINTask<NSArray<NSString *> *> *allTask = [PINTask<NSString *> all:@[sourceTaskA, sourceTaskB]];
        runTaskAndExpectToFulfillWith(self, allTask, @[valueA, valueB]);
    });
    it(@"rejects when any source task rejects", ^{
        NSString *valueA = stringFixture();
        NSError *errorB = errorFixture();
        PINTask<NSString *> *sourceTaskA = [PINTask<NSString *> withValue:valueA];
        PINTask<NSString *> *sourceTaskB = [PINTask<NSString *> withError:errorB];
        
        PINTask<NSArray<NSString *> *> *allTask = [PINTask<NSString *> all:@[sourceTaskA, sourceTaskB]];
        runTaskAndExpectToRejectWith(self, allTask, errorB);
    });
});

SpecEnd
