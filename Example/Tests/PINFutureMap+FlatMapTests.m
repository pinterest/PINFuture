//
//  FlatMapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapFlatMapSpecs)

describe(@"flatMap", ^{
    it(@"can return resolved promise", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> succeedWith:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSNumber *, NSString *> flatMap:futureA executor:[PINExecutor immediate] transform:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> succeedWith:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });

    it(@"can return rejected promise", ^{
        NSString *valueA = stringFixture();
        NSError *errorB = errorFixture();
        PINFuture<NSString *> *futureA = [PINFuture<NSString *> succeedWith:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSString *, NSString *> flatMap:futureA executor:[PINExecutor immediate] transform:^PINFuture<NSString *> * _Nonnull(NSString * _Nonnull fromValue) {
            return [PINFuture<NSString *> failWith:errorB];
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
