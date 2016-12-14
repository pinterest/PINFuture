//
//  UtilTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureAllSpecs)

describe(@"all", ^{
    it(@"resolves if all source promises resolve", ^{
        NSString *value1 = stringFixture();
        NSString *value2 = stringFixture();
        PINFuture<NSString *> *source1 = [PINFuture<NSString *> withValue:value1];
        PINFuture<NSString *> *source2 = [PINFuture<NSString *> withValue:value2];
        PINFuture<NSArray<NSString *> *> *arrayFuture = [PINFuture<NSString *> all:@[source1, source2]];
        expectFutureToResolveWith(self, arrayFuture, @[value1, value2]);
    });

    it(@"rejects if any source promise rejects", ^{
        NSString *value1 = stringFixture();
        NSError *error2 = errorFixture();
        PINFuture<NSString *> *source1 = [PINFuture<NSString *> withValue:value1];
        PINFuture<NSString *> *source2 = [PINFuture<NSString *> withError:error2];
        PINFuture<NSArray<NSString *> *> *arrayFuture = [PINFuture<NSString *> all:@[source1, source2]];
        expectFutureToRejectWith(self, arrayFuture, error2);
    });
});

SpecEnd
