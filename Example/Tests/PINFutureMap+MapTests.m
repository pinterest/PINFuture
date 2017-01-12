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
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> withValue:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSNumber *, NSString *> map:futureA executor:[PINExecutor immediate] transform:^NSString * _Nonnull(NSNumber * _Nonnull fromValue) {
            return valueB;
        }];
        expectFutureToFulfillWith(self, futureB, valueB);
    });
});

describe(@"mapToValue", ^{
    it(@"can return a value of a different type", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> withValue:valueA];
        PINFuture<NSString *> *futureB = [PINFutureMap<NSNumber *, NSString *> mapToValue:futureA value:valueB];
        expectFutureToFulfillWith(self, futureB, valueB);
    });
});

SpecEnd
