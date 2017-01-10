//
//  MapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapMapSpecs)

describe(@"map", ^{
    it(@"can return a value of a different type", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> succeedWith:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSNumber *, NSString *> map:futureA executor:[PINExecutor immediate] transform:^PINResult<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINResult<NSString *> succeedWith:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });
    
    it(@"can cause a failure", ^{
        NSNumber *valueA = numberFixture();
        NSError *error = errorFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> succeedWith:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSNumber *, NSString *> map:futureA executor:[PINExecutor immediate] transform:^PINResult<NSString *> *(NSNumber *fromValue) {
            return [PINResult<NSString *> failWith:error];
        }];
        expectFutureToRejectWith(self, futureB, error);
    });
});

SpecEnd
