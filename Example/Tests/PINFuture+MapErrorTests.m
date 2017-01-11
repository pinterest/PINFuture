//
//  PINFuture+MapError.m
//  PINFuture
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapErrorSpecs)

describe(@"mapError", ^{
    it(@"can return a new error", ^{
        NSError *error1 = errorFixture();
        NSError *error2 = errorFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error1];
        PINFuture<NSString *> *mapped = [source executor:[PINExecutor immediate] mapError:^PINResult<NSString *> *(NSError *error) {
            return [PINResult<NSString *> withError:error2];
        }];
        expectFutureToRejectWith(self, mapped, error2);
    });
});

SpecEnd
