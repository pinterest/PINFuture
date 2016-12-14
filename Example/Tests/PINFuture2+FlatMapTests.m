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

SpecBegin(PINFuture2FlatMapSpecs)

describe(@"flatMap", ^{
    it(@"can return resolved promise", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> withValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> withValue:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });

    it(@"can return rejected promise", ^{
        NSString *valueA = stringFixture();
        NSError *errorB = errorFixture();
        PINFuture<NSString *> *futureA = [PINFuture<NSString *> withValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSString *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSString * _Nonnull fromValue) {
            return [PINFuture<NSString *> withError:errorB];
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
