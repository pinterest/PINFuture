//
//  PINFuture+GatherSomeTests.m
//  PINFuture
//
//  Created by Chris Danford on 8/16/17.
//  Copyright © 2017 Pinterest. All rights reserved.
//


// https://github.com/Specta/Specta

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureGatherSomeSpecs)

describe(@"gatherSome", ^{
    it(@"resolves with a mix of resolved and rejected futures ", ^{
        NSError *error1 = errorFixture();
        NSString *value2 = stringFixture();
        PINFuture<NSString *> *source1 = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *source2 = [PINFuture<NSString *> withValue:value2];
        PINFuture<NSArray *> *arrayFuture = [PINFuture<NSString *> gatherSome:@[source1, source2]];
        expectFutureToFulfillWith(self, arrayFuture, @[[NSNull null], value2]);
    });
});

SpecEnd
