//
//  PINFuture+FlatMapError.m
//  PINFuture
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureFlatMapErrorSpecs)

describe(@"flatMapError", ^{
    it(@"can return a resolved future", ^{
        NSError *error1 = errorFixture();
        NSString *value2 = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *mapped = [source executor:[PINExecutor immediate] flatMapError:^PINFuture<NSString *> *(NSError *error) {
            return [PINFuture withValue:value2];
        }];
        expectFutureToFulfillWith(self, mapped, value2);
    });

    it(@"can return a rejected future", ^{
        NSError *error1 = errorFixture();
        NSError *error2 = errorFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *mapped = [source executor:[PINExecutor immediate] flatMapError:^PINFuture<NSString *> *(NSError *error) {
            return [PINFuture withError:error2];
        }];
        expectFutureToRejectWith(self, mapped, error2);
    });

    it(@"raises exception when nil is returned instead of a PINFuture", ^{
        NSError *error1 = errorFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        expect(^{
            __unused PINFuture<NSString *> *mapped = [source executor:[PINExecutor immediate] flatMapError:^PINFuture<NSString *> *(NSError *error) {
                return nil;
            }];
        }).to.raiseAny();
    });
});

SpecEnd
