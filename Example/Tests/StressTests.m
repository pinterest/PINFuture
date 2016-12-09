//
//  StressTests.m
//  PINFutureTests
//
//  Created by Chris Danford on 12/5/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(StressSpecs)

describe(@"stress test", ^{
    it(@"handles large numbers of callbacks", ^{
        NSUInteger numChildren = 10000;
        NSNumber *value = numberFixture();
        PINFuture<NSNumber *> *sourceFuture = [PINFuture<NSNumber *> withValue:value];
        
        NSMutableArray<PINFuture<NSNumber *> *> *sourceFutures = [[NSMutableArray alloc] initWithCapacity:numChildren];
        for (NSUInteger i = 0; i < numChildren; i++) {
            [sourceFutures addObject:sourceFuture];
        }
        
        PINFuture<NSArray<NSNumber *> *> *arrayFuture = [PINFuture<NSNumber *> all:sourceFutures];
        NSMutableArray<NSNumber *> *expectedValue = [[NSMutableArray alloc] initWithCapacity:numChildren];
        for (NSUInteger i = 0; i < numChildren; i++) {
            [expectedValue addObject:value];
        }
        
        expectFutureToResolveWith(self, arrayFuture, expectedValue);
    });
});

SpecEnd
