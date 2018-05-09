//
//  PINFuture+Delay.m
//  PINFuture
//
//  Created by Chris Danford on 1/31/17.
//  Copyright © 2018 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureDelaySpecs)

describe(@"Delay", ^{
    it(@"can delay", ^{
        PINFutureNoValue *delay = [PINFuture delay:0];
        expectFutureToFulfillWith(self, delay, [NSNull null]);
    });
});

SpecEnd
