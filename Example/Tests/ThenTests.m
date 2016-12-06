//
//  ThenTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "PINThen.h"
#import "TestUtil.h"

SpecBegin(ThenSpecs)

describe(@"then", ^{

    it(@"testResolveToResolve", ^{
        NSNumber *valueA = @1;
        NSString *valueB = @"A";
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINThen<NSNumber *, NSString *> then:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithValue:valueB];
        } failure:^PINFuture<NSString *> * _Nonnull(NSError * _Nonnull error) {
            XCTAssertTrue(NO);
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });
    
    it(@"testResolveToRejection", ^{
        NSNumber *valueA = @1;
        NSError *errorB = [[NSError alloc] init];
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithValue:valueA];
        PINFuture<NSString *> *futureB = [PINThen<NSNumber *, NSString *> then:futureA success:^PINFuture<NSString *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            return [PINFuture<NSString *> futureWithError:errorB];
        } failure:^PINFuture<NSString *> * _Nonnull(NSError * _Nonnull error) {
            XCTAssertTrue(NO);
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
    
    it(@"testRejectionToResolve", ^{
        NSError *errorA = [[NSError alloc] init];
        NSNumber *valueB = @1;
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithError:errorA];
        PINFuture<NSNumber *> *futureB = [PINThen<NSNumber *, NSNumber *> then:futureA success:^PINFuture<NSNumber *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            XCTAssertTrue(NO);
        } failure:^PINFuture<NSNumber *> * _Nonnull(NSError * _Nonnull error) {
            return [PINFuture<NSNumber *> futureWithValue:valueB];
        }];
        expectFutureToResolveWith(self, futureB, valueB);
    });
    
    it(@"testRejectionToRejection", ^{
        NSError *errorA = [[NSError alloc] init];
        NSError *errorB = [[NSError alloc] init];
        PINFuture<NSNumber *> *futureA = [PINFuture<NSNumber *> futureWithError:errorA];
        PINFuture<NSNumber *> *futureB = [PINThen<NSNumber *, NSNumber *> then:futureA success:^PINFuture<NSNumber *> * _Nonnull(NSNumber * _Nonnull fromValue) {
            XCTAssertTrue(NO);
        } failure:^PINFuture<NSNumber *> * _Nonnull(NSError * _Nonnull error) {
            return [PINFuture<NSNumber *> futureWithError:errorB];
        }];
        expectFutureToRejectWith(self, futureB, errorB);
    });
});

SpecEnd
