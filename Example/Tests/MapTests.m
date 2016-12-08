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
    it(@"can change value", ^{
        NSNumber *valueA = @1;
        NSString *valueB = @"A";
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINFuture2<NSNumber *, NSString *> map:futureA success:^NSString * _Nonnull(NSNumber * _Nonnull fromValue) {
            return valueB;
        } failure:^NSError * _Nonnull(NSError * _Nonnull error) {
            XCTAssertTrue(NO);
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });
    
    it(@"can change error", ^{
        NSError *errorA = [[NSError alloc] init];
        NSError *errorB = [[NSError alloc] init];
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithError:errorA];
        PINFuture<NSNumber *> *futureB = [PINFuture2<NSNumber *, NSNumber *> map:futureA success:^NSNumber * _Nonnull(NSNumber * _Nonnull fromValue) {
            XCTAssertTrue(NO);
        } failure:^NSError * _Nonnull(NSError * _Nonnull error) {
            return errorB;
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
