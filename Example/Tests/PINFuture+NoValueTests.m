//
//  PINFuture+NoValueTests.m
//  PINFuture
//
//  Created by Chris Danford on 1/31/17.
//  Copyright © 2018 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureNoValueSpecs)

describe(@"NoValue", ^{
    it(@"can mapToNoValue", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withValue:value];
        PINFutureNoValue *mapped = [source mapToNoValue];
        
        expectFutureToFulfillWith(self, mapped, [NSNull null]);
    });

    it(@"can mapToNoValue", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withValue:value];
        PINFutureNoValue *mapped = [source mapToNoValue];
        
        expectFutureToFulfillWith(self, mapped, [NSNull null]);
    });
});

SpecEnd
