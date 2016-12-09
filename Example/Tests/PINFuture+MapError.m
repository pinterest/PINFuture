//
//  PINFuture+MapError.m
//  PINFuture
//
//  Created by Chris Danford on 12/8/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapErrorSpecs)

describe(@"mapError", ^{
    it(@"can return a new error", ^{
        NSError *error1 = errorFixture();
        NSError *error2 = errorFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> futureWithError:error1];
        PINFuture<NSString *> *mapped = [source mapError:^NSError *(NSError *error) {
            return error2;
        }];
        expectFutureToRejectWith(self, mapped, error2);
    });
});

SpecEnd
