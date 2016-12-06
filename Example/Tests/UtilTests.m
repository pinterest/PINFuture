//
//  UtilTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/5/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "PINFuture+Util.h"
#import "TestUtil.h"

SpecBegin(UtilSpecs)

describe(@"all", ^{
    
    it(@"resolves if all source promises resolve", ^{
        NSNumber *value1 = @1;
        NSNumber *value2 = @2;
        PINFuture<NSNumber *> *source1 = [PINFuture<NSNumber *> futureWithValue:value1];
        PINFuture<NSNumber *> *source2 = [PINFuture<NSNumber *> futureWithValue:value2];
        PINFuture<NSArray<NSNumber *> *> *arrayFuture = [PINFuture<NSNumber *> all:@[source1, source2]];
        expectFutureToResolveWith(self, arrayFuture, @[value1, value2]);
    });
    
    it(@"rejects if any source promise rejects", ^{
        NSNumber *value1 = @1;
        NSError *error2 = [[NSError alloc] init];
        PINFuture<NSNumber *> *source1 = [PINFuture<NSNumber *> futureWithValue:value1];
        PINFuture<NSNumber *> *source2 = [PINFuture<NSNumber *> futureWithError:error2];
        PINFuture<NSArray<NSNumber *> *> *arrayFuture = [PINFuture<NSNumber *> all:@[source1, source2]];
        expectFutureToRejectWith(self, arrayFuture, error2);
    });
});

SpecEnd
