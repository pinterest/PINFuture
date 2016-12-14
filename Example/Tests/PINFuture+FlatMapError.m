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
    it(@"can return a resolved promise", ^{
        NSError *error1 = errorFixture();
        NSString *value2 = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *mapped = [source flatMapError:^PINFuture<NSString *> *(NSError *error) {
            return [PINFuture withValue:value2];
        }];
        expectFutureToResolveWith(self, mapped, value2);
    });

    it(@"can return a rejected promise", ^{
        NSError *error1 = errorFixture();
        NSError *error2 = errorFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *mapped = [source flatMapError:^PINFuture<NSString *> *(NSError *error) {
            return [PINFuture withError:error2];
        }];
        expectFutureToRejectWith(self, mapped, error2);
    });
});

SpecEnd
