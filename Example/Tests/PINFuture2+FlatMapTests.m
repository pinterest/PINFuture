//
//  FlatMapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFuture2FlatMapSpecs)

describe(@"flatMap", ^{
    it(@"can return resolved promise", ^{
        NSNumber *valueA = numberFixture();
        NSString *valueB = stringFixture();
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithValue:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });

    it(@"can return rejected promise", ^{
        NSString *valueA = stringFixture();
        NSError *errorB = errorFixture();
        PINFuture<NSString *> *futureA = [PINFuture<NSString *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSString *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSString * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithError:errorB];
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
