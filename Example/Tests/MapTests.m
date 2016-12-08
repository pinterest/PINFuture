//
//  MapTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(MapSpecs)

describe(@"map", ^{
    it(@"can return a new value", ^{
        NSNumber *valueA = @1;
        NSString *valueB = @"A";
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> map:futureA success:^NSString * _Nonnull(NSNumber * _Nonnull fromValue) {
            return valueB;
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });
});

SpecEnd
