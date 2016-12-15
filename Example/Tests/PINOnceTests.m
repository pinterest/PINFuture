//
//  PINOnceTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/14/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINOnce.h"

SpecBegin(PINOnceSpecs)

describe(@"once", ^{
    it(@"only calls block once", ^{
        PINOnce *once = [PINOnce new];
        __block NSUInteger callCount = 0;
        [once performOnce:^{
            callCount++;
        }];
        [once performOnce:^{
            callCount++;
        }];
        expect(callCount).to.equal(1);
    });
});

SpecEnd
