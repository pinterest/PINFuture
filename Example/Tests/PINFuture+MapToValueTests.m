//
//  PINFuture+MapToValue.m
//  PINFuture
//
//  Created by Chris Danford on 1/31/17.
//  Copyright © 2017 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapToValueSpecs)

describe(@"mapToValue", ^{
    it(@"can mapToValue", ^{
        NSNumber *numberValue = numberFixture();
        NSString *stringValue = stringFixture();
        PINFuture<NSNumber *> *source = [PINFuture<NSNumber *> withValue:numberValue];
        PINFuture<NSString *> *mapped = [PINFuture<NSString *> map:source toValue:stringValue];
        expectFutureToFulfillWith(self, mapped, stringValue);
    });

    it(@"can mapToNoValue", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withValue:value];
        PINFutureNoValue *mapped = [source mapToNoValue];
        
        expectFutureToFulfillWith(self, mapped, [NSNull null]);
    });
});

SpecEnd
