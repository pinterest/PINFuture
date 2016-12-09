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

SpecBegin(FlatMapSpecs)

describe(@"flatMap", ^{
    it(@"can return resolved promise", ^{
        NSNumber *valueA = @1;
        NSString *valueB = @"A";
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithValue:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });

    it(@"can return rejected promise", ^{
        NSNumber *valueA = @1;
        NSError *errorB = [[NSError alloc] init];
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> flatMap:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithError:errorB];
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
